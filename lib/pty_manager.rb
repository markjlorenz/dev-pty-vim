require 'pty'
require 'io/console'

require_relative 'key_listener'
require_relative 'key_sender'
require_relative 'registration_server'
require_relative 'command_interface'
require_relative 'vim_interface'

Thread.abort_on_exception = true

class PtyManager
  def initialize(registration_port, key_port, key_file, vim_rc)
    pty_m, @pty_s        = PTY.open
    @key_file            = key_file
    @vim_rc_path         = vim_rc
    @vim_rc              = File.new(vim_rc)
    @vim_interface       = VimInterface.new pty_m
    @registration_server = RegistrationServer.new registration_port, @vim_rc
    @key_listener        = KeyListener.new(key_port, remote_key_callback)
    @communication       = CommandInterface.new @registration_server

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
    }
  end
  private :register_callbacks

  def save_key key
    File.open(@key_file, 'a') { |f| f.putc key }
  end
  private :save_key

  def send_key key
    clients = @registration_server.clients
    sender  = KeySender.new clients, key
    sender.send
  end
  private :send_key

  def spawn_vim
    spawn("vim", in: @pty_s, out: STDOUT)
  end
  private :spawn_vim

  def clear_key_file
    File.unlink(@key_file) if File.exists?(@key_file)
  end
  private :clear_key_file

end
