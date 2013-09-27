require 'socket'

Thread.abort_on_exception = true

class KeyListener
  def initialize port, callback
    @port     = port
    @callback = callback
    listen
  end

  def listen
    Thread.new do
      Socket.tcp_server_loop @port, &register_listener
    end
  end
  private :listen

  def register_listener
    ->(raw_socket, client_info) {
      Thread.new do
        key = raw_socket.read
        @callback[key]
        raw_socket.close
      end
    }
  end
  private :register_listener

end
