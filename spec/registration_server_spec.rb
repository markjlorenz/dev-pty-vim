# This test fails, even though it excersises the code exactly as I want.
# There obviosly something about `expect().to receive()` that I don't understand
#
# LITTLE HELP?
#
require_relative '../lib/registration_server'

describe RegistrationServer do
  context "a new registrant" do
    before do
      server.instance_variable_set "@vim_rc", vim_rc
      server.start
    end

    let (:server_port)  { 2001 }
    let (:vim_rc)       { StringIO.new "colorscheme default\n" }
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

    it { should eq(vim_rc.string) }
  end

  context "calling an event" do

    before do 
      server.instance_variable_set "@vim_rc", vim_rc
      server.on :connection, callback 
    end

    let (:server_port)  { 2001 }
    let (:vim_rc)       { StringIO.new "colorscheme default\n" }
    let (:server)       { RegistrationServer.new(server_port) }
    let (:client)       { "a client" }
    # help!?  code behaves as expected, but tests fail
    let (:callback)     { ->(client){ raise "This is exactly what's supposed to be called.  Why U fail?"} } #little help?
    #let (:callback)     { ->(client){} }
    
    it "receives call" do
      expect{ callback }.to receive(:[]).with(client)
      server.promises.connection client
    end

  end
end

