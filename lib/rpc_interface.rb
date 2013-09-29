require 'socket'

module RPCInterface
  def connect registration_host, port
    message = { 
        notify_port: App.options.key_port,
      register_port: App.options.registration_port 
    }.to_json

    Socket.tcp(registration_host, port) { |socket|
      socket.write message
      socket.close_write
    }
  end

  def clients
    p registration_server.clients
  end
end
