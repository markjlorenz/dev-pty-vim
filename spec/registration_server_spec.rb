require_relative '../lib/registration_server'

describe RegistrationServer do
  context "a new registrant" do
    before do
      server.start
    end

    let (:server_port)  { 2001 }
    let (:server)       { RegistrationServer.new(server_port) }
    let (:client)       { TCPSocket.new('localhost', server_port) }
    let (:message)      { {notify_port: 9000}.to_json }

    subject do 
      Socket.tcp('localhost', server_port) {|client|
        client.write message
        client.close_write
        client.read
      }
    end

    it { should include('Time is') }

  end
end

