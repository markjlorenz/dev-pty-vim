require 'socket'

Thread.abort_on_exception = true

class KeySender
  def initialize clients, key
    @clients = clients
    @key    = key
  end

  def send
    @clients.each &tcp_send
  end

  def tcp_send
    ->(client){
      notify_adr = [ client.notify_adr.host, client.notify_adr.port ]
      Socket.tcp(*notify_adr) do |client_socket|
        client_socket.write @key
        client_socket.close_write
      end
    }
  end
  private :tcp_send

end
