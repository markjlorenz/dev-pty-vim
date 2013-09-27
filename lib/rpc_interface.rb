require 'json'
require 'socket'
require_relative 'app'

module RPCInterface
  class << self
    def connect registration_host, port
      message = { notify_port: App.options.key_port }.to_json

      Socket.tcp(registration_host, port) { |socket|
        socket.write message
        socket.close_write
      }
    end
  end
end
