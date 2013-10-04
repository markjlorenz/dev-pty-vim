require_relative '../lib/key_listener'

describe KeyListener do
  context "calls update proc when key are recived" do
    before do
      expect(callback).to receive(:[]).with(message)
      Thread.new do
        listener.start
      end

    end
    
    let(:port)     { 2003 }
    let(:callback) { ->(key){} }
    let(:listener) { KeyListener.new port, callback }
    let(:message)  { "j" }
    
    it do 
      Socket.tcp('localhost', port) {|client|
        client.write message
        client.close_write
      }
      sleep 0.1
    end
    
  end
end
