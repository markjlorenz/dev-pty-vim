require 'socket'
require 'ostruct'
require 'json'
require 'uri'

Thread.abort_on_exception = true

# Registration packet includes:
#   notify_port: the port to send updates to
#
# Clients include:
#   notify_adr: #host and #port
class RegistrationServer
  attr_reader :clients

  def initialize port=2000, vim_rc=File.new(File.expand_path "~/.vimrc")
    @port    = port
    @vim_rc  = vim_rc
    @loop    = nil
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
        notify_adr: URI::HTTP.build(host: client_host(client_info), port: socket.notify_port)
        })

        @clients << client
        puts "Client connected: #{client.info}"
        puts "       with data: #{client.socket}"
        raw_socket.puts @vim_rc.read
        raw_socket.close
      end
    }
  end
  private :register_observer

  def client_host(client_info)
    # URI::HTTP needs IPv6 address to be wrapped in square braces, (e.g. [::1]). but client_info.ip_address
    # returns in like "::1" so we wrap it.
    #
    client_ip = client_info.ip_address
    client_host = client_ip.match(/^::/) ? "[#{client_ip}]" : client_ip
  end
  private :client_host

  AlreadyStarted = Class.new(StandardError)
end
