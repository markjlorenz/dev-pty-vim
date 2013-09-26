require 'socket'

Thread.abort_on_exception = true

class KeySender
  def initialize clients, keys
    @clients = clients
    @keys    = keys
  end

  def send
    @clients.each &tcp_send
  end

  def tcp_send
    ->(client){
      notify_adr = [ client.notify_adr.host, client.notify_adr.port ]
      Socket.tcp(*notify_adr) do |client_socket|
        client_socket.write @keys
        client_socket.close_write
      end
    }
  end
  private :tcp_send

end
