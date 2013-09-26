module ExitByPipe
  def self.join kill_pipe = 'kill_pipe'
    `mkfifo #{kill_pipe}` unless File.exists?(kill_pipe)
    at_exit do
      File.unlink kill_pipe
      yield if block_given?
    end
    File.open(kill_pipe) { exit }
  end
end

