require_relative '../lib/key_listener'

describe KeyListener do
  context "calls update proc when key are recived" do
    after do
      Thread.new do
        listener.start
      end
      Socket.tcp('localhost', port) {|client|
        client.write message
        client.close_write
      }
    end
    
    let(:port)     { 2003 }
    let(:callback) { ->(key){} }
    let(:listener) { KeyListener.new port, callback }
    let(:message)  { "j" }
    
    subject { callback }
    it { should receive(:call).with(message) }
  end
end
