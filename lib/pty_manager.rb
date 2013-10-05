require 'pty'
require 'io/console'

require_relative 'key_listener'
require_relative 'key_sender'
require_relative 'registration_server'
require_relative 'command_interface'
require_relative 'vim_interface'
require_relative 'app'

Thread.abort_on_exception = true

class PtyManager
  def initialize
    opt                  = App.options
    pty_m, @pty_s        = PTY.open
    @key_file            = opt.key_file
    @vim_rc_path         = opt.vim_rc
    @vim_interface       = VimInterface.new pty_m
    @registration_server = RegistrationServer.new opt.registration_port, @vim_rc_path
    @key_listener        = KeyListener.new(opt.key_port, remote_key_callback)
    @communication       = CommandInterface.new @registration_server
    @key_sender          = KeySender.new []

    register_callbacks
  end

  def start
    spawn_vim
    start_key_control_loop
    @registration_server.start
    @key_listener.start
    @communication.start
  end

  def start_key_control_loop
    Thread.new {
      loop do
        char = STDIN.getch
        save_key  char
        send_key  char
        @vim_interface << char
      end
    }
  end
  private :start_key_control_loop

  def remote_key_callback
    ->(key){
      save_key  key
      @vim_interface << key
    }
  end
  private :remote_key_callback

  def register_callbacks
    @registration_server.on :connection, ->(client) {
      @vim_interface << ":echo 'A new client connected! -- #{client.register_adr}'\n"
      @key_sender     = KeySender.new @registration_server.clients
    }

    @communication.on :connected, ->(server, vimrc) {
      remote_vim_rc_path = App.path.join("tmp", "#{server.host}:#{server.port}")
      File.write(remote_vim_rc_path, vimrc)
      @registration_server.vim_rc = remote_vim_rc_path # Serve up the new vimrc instead
      @vim_interface << ":qa!\n"                  # bye-bye vim
      spawn_vim(remote_vim_rc_path)               # come back with a new vimrc
      @vim_interface << ":echo 'Connected to server! -- #{server}'\n"
    }
  end
  private :register_callbacks

  def save_key key
    File.open(@key_file, 'a') { |f| f.putc key }
  end
  private :save_key

  def send_key key
    @key_sender.send key
  end
  private :send_key

  def spawn_vim(vim_rc=@vim_rc_path)
    spawn("vim -u #{vim_rc}", in: @pty_s, out: STDOUT)
    sleep 0.2 # give it a moment to boot
  end
  private :spawn_vim

  def clear_key_file
    File.unlink(@key_file) if File.exists?(@key_file)
  end
  private :clear_key_file

end
