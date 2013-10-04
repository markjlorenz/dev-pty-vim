require 'socket'
require 'uri'

module RPCInterface
  def connect registration_host, port
    message = { 
        notify_port: App.options.key_port,
      register_port: App.options.registration_port 
    }.to_json

    Socket.tcp(registration_host, port) { |socket|
      socket.write message
      socket.close_write

      to = URI::HTTP.build(host: registration_host, port: port)
      promises.connected(to, socket.read)
    }
  end

  def clients
    p registration_server.clients
  end
end
