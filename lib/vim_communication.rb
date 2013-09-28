require 'json'
require_relative 'app'
require_relative 'rpc_interface'

Thread.abort_on_exception = true

# Messages are JSON of the format:
# {
#   "a_method_name": [method_arg1, method_arg2]
# }
class VimCommunication
  include RPCInterface

  attr_reader :registration_server
  def initialize registration_server
    @registration_server = registration_server
    @vim_com_pipe        = App.path.join('tmp', 'vim_com_pipe')
    setup_com_pipe
  end
  
  def start
    Thread.new do
      loop {
        process File.read(@vim_com_pipe)
      }
    end
  end

  def process message
    commands = JSON.parse(message)
    commands.each do |method_name, args|
      public_send method_name.to_sym, *args
    end
  end

  def path
    @vim_com_pipe
  end

  def setup_com_pipe
    `mkfifo #{@vim_com_pipe}` unless File.exists?(@vim_com_pipe)
    at_exit { File.unlink(@vim_com_pipe) if File.exists?(@vim_com_pipe) }
  end
  private :setup_com_pipe
end

