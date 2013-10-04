require 'json'
require_relative '../lib/command_interface'

describe CommandInterface do
  context "responding to a comunique" do
    before do 
      communicator.stub target_meth
    end

    let(:message)      { { target_meth => [] }.to_json }
    let(:registration) { double(RegistrationServer).as_null_object }
    let(:communicator) { VimCommunication.new registration }
    let(:target_meth)  { :test_method }
    
    it "receives the message" do
      communicator.should receive(target_meth) 
      communicator.start
      File.write(communicator.path, message)
      sleep 0.1
    end 

  end
end

