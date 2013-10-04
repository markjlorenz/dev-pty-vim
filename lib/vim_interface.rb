require 'thread'

class VimInterface
  def initialize pty_m
    @pty_m = pty_m
    @queue = Queue.new
    start_worker
  end

  def push key
    @queue << key
  end
  alias :<< :push

  def start_worker
    Thread.new do
      loop { @pty_m << @queue.pop }
    end
  end
end
