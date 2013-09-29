require 'stringio'
require_relative '../lib/vim_interface'

describe VimInterface do
  before do
    vim_iface << input
    sleep 0.01 #probably a better way to do this
  end

  let(:input)     { "I'm a string" }
  let(:pty_m)     { StringIO.new }
  let(:vim_iface) { VimInterface.new pty_m }
  
  subject { pty_m }
  its(:string) { should eql(input) }
end
