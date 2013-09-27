require 'pty'
require 'io/console'

require_relative 'key_listener'
require_relative 'key_sender'
require_relative 'registration_server'

class PtyManager
  def initialize(registration_port, key_port, key_file, vim_rc)
    @pty_m, @pty_s     = PTY.open
    @key_file          = key_file
    @vim_rc_path       = vim_rc
    @vim_rc            = File.new(vim_rc)

    start_key_control_loop
    RegistrationServer.new(registration_port, @vim_rc).start
    KeyListener.new(key_port, remote_key_callback).start
  end

  def start_key_control_loop
    Thread.new {
      loop do
        char = STDIN.getch
        save_key  char
        send_key  char
        @pty_m << char
      end
    } 
  end

  def remote_key_callback
    ->(key){
      save_key  char
      @pty_m << char
    }
  end

  def save_key key
    File.open(@key_file, 'a') { |f| f.putc char }
  end
  private :save_key

  def send_key key
    KeySender.new clients, char
  end
  private :send_key

  def spawn_vim
    spawn("vim", in: @pty_s, out: STDOUT)
  end
  private :spawn_vim

  def clear_key_file
    File.unlink(@key_file) if File.exists?(@key_file)
  end
  
end
