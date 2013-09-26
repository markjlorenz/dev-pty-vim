require 'socket'
require 'ostruct'
require 'json'
require 'uri'

Thread.abort_on_exception = true

# Registration packet includes:
#   notify_port: the port to send updates to
class RegistrationServer
  attr_reader :clients

  def initialize port=2000
    @port = port
    @loop = nil
    @clients = []
  end

  def start
    raise AlreadyStarted if @loop
    @loop = Thread.new do
      Socket.tcp_server_loop @port, &register_observer
    end
  end

  def register_observer
    ->(raw_socket, client_info) {
      Thread.new do
        socket = OpenStruct.new JSON.parse(raw_socket.read)
        client = OpenStruct.new({ 
            socket: socket,
              info: Socket.unpack_sockaddr_in(client_info),
        notify_adr: URI::HTTP.build(host: client_info.ip_address, port: socket.notify_port)
        })

        @clients << client
        puts "Client connected: #{client.info}"
        puts "       with data: #{client.socket}"
        raw_socket.puts "Time is #{Time.now}"
        raw_socket.close
      end
    }
  end

  AlreadyStarted = Class.new(StandardError)
end
