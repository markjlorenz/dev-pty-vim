require 'socket'
require 'ostruct'
require 'json'
require 'uri'

require_relative 'promise'

Thread.abort_on_exception = true

# Registration packet includes:
#     notify_port: the port to send updates to
#   register_port: the port to register with this client
#
# Clients include:
#   notify_adr: #host and #port
#   notify_adr: #host and #port
class RegistrationServer
  include DelegatePromises
  attr_reader :clients

  def initialize port=2000, vim_rc=File.new(File.expand_path "~/.vimrc")
    @port     = port
    @vim_rc   = vim_rc
    @loop     = nil
    @clients  = []

    @promises  = Promise.new connection: [ ->(client){} ]
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
          notify_adr: URI::HTTP.build(host: client_info.ip_address, port: socket.notify_port),
        register_adr: URI::HTTP.build(host: client_info.ip_address, port: socket.register_port)
        })

        @clients << client
        raw_socket.puts @vim_rc.read
        raw_socket.close
        promises.connection(client)
      end
    }
  end
  private :register_observer

  AlreadyStarted = Class.new(StandardError)
end
