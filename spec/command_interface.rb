require 'json'
require_relative '../lib/command_interface'

describe CommandInterface do
  context "responding to a comunique" do
    after do 
      communicator.start
      File.write(communicator.path, message)
    end

    let(:message)      { { target_meth => [] }.to_json }
    let(:communicator) { described_class.new }
    let(:target)       { RPCInterface.stub(target_meth) }
    let(:target_meth)  { :test_method }
    
    subject { target }
    it { should receive(target_meth) }
  end
end

