require_relative '../lib/key_listener'

describe KeyListener do
  context "calls update proc when key are recived" do
    before do
      # expect(callback).to receive(:[]).with(message)
      Thread.new do
        listener.start
      end

    end

    let(:port)     { 2003 }
    let(:callback) { ->(key){raise StandardError} }
    let(:listener) { KeyListener.new port, callback }
    let(:message)  { "j" }

    it "calls the callback" do
      expect do
        Socket.tcp('localhost', port) {|client|
          client.write message
        }
      end.to raise_error(StandardError)
    end

  end
end
