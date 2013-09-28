# This test fails, even though it excersises the code exactly as I want.
# There obviosly something about `expect().to receive()` that I don't understand
#
# LITTLE HELP?
#
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
    let(:callback) { ->(key){} }  # I if you `raise "HI"` in the body of this proc, it's raised (so clearly called)
    let(:listener) { KeyListener.new port, callback }
    let(:message)  { "j" }
    
    it do 
      Socket.tcp('localhost', port) {|client|
        client.write message
        client.close_write
      }
    end
    
  end
end
