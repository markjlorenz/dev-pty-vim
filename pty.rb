#! /usr/bin/env ruby

require_relative 'lib/exit_by_pipe'
require_relative 'lib/pty_manager'
require_relative 'lib/options'

Thread.abort_on_exception = true

opt = Options.parse!
PtyManager.new(opt.registration_port, opt.key_port, opt.key_file, opt.vim_rc).start

ExitByPipe.join 'kill'

# Synchronize new client with past events
#if ARGV[0]
  #IO.copy_stream ARGV[0], pty_m
#end
