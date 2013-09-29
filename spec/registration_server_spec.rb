require_relative '../lib/registration_server'

describe RegistrationServer do
  context "a new registrant" do
    before do
      server.start
    end

    let (:server_port)  { 2001 }
    let (:vim_rc)       { StringIO.new "colorscheme default" }
    let (:server)       { RegistrationServer.new(server_port, vim_rc) }
    let (:client)       { TCPSocket.new('localhost', server_port) }
    let (:message)      { {notify_port: 9000}.to_json }

    subject do 
      Socket.tcp('localhost', server_port) {|client|
        client.write message
        client.close_write
        client.read
      }
    end

    it { should include(vim_rc.string) }
  end

  context "calling an event" do

    before { server.on :connection, callback }

    let (:server_port)  { 2001 }
    let (:vim_rc)       { StringIO.new "colorscheme default" }
    let (:server)       { RegistrationServer.new(server_port, vim_rc) }
    let (:client)       { "a client" }
    let (:callback)     { ->(client){} }
    
    it "receives call" do
      expect{ callback }.to receive(:[]).with(client)
      server.send :connection, client
    end

  end
end

