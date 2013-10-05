require 'socket'

Thread.abort_on_exception = true

class KeySender
  def initialize clients
    @clients     = clients
    @connections = {}
    connect_all
  end

  def send(key)
    @clients.each &thread_send(key)
  end

  def connect_all
    @connections = @clients.inject({}) do |memo, client|
      notify_adr  = [ client.notify_adr.host, client.notify_adr.port ]
      socket      = Socket.tcp(*notify_adr)
      socket.sync = true
      memo.update client => socket
    end
  end
  private :connect_all

  def thread_send(key)
    ->(client){
      Thread.new {
        @connections[client].write key
      }
    }
  end
  private :thread_send

end
