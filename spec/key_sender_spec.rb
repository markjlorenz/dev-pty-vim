require_relative '../lib/key_sender'

describe KeySender do
  context "sending updates" do
    before do
      Thread.new do
        described_class.new(clients).send(key)
      end
    end

    let(:client1_port)  { 2000 }
    let(:clients)       { [client1] }
    let(:key)          { "k" }

    let(:client1) do
      OpenStruct.new notify_adr: OpenStruct.new( host: 'localhost', port: client1_port )
    end
    let(:c1_listener)  do
      listener  = TCPServer.new client1_port
      client    = listener.accept
      client.getc
    end

    subject { c1_listener }
    it { should include(key) }

  end
end

