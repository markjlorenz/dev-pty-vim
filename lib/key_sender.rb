require 'socket'

Thread.abort_on_exception = true

class KeySender
  def initialize clients, key
    @clients     = clients
    @key         = key
    @connections = {}
    connect_all
  end

  def send
    @clients.each &thread_send
  end

  def connect_all
    @connections = @clients.inject({}) do |memo, client|
      notify_adr  = [ client.notify_adr.host, client.notify_adr.port ]
      socket      = Socket.tcp(*notify_adr)
      socket.sync = true
      memo.update client => socket
    end
  end

  def thread_send
    ->(client){
      Thread.new {
        @connections[client].write @key
        @connections[client].close_write
      }
    }
  end
  private :thread_send

end
