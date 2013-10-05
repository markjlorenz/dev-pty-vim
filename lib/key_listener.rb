require 'socket'

Thread.abort_on_exception = true

class KeyListener
  def initialize port, callback
    @port     = port
    @callback = callback
  end

  def start
    Thread.new do
      Socket.tcp_server_loop @port, &register_listener
    end
  end

  def register_listener
    ->(raw_socket, client_info) {
      Thread.new do
        loop {
          key = raw_socket.getc
          @callback[key]
        }
      end
    }
  end
  private :register_listener

end
