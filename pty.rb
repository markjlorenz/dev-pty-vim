#! /usr/bin/env ruby
require 'pty'
require 'io/console'
require 'stringio'
require_relative 'lib/exit_by_pipe'

pty_m, pty_s  = PTY.open
key_file      = 'tmp/keys'
vim_pid       = spawn("vim", in: pty_s, out: STDOUT)
File.unlink(key_file) if File.exists?(key_file)

# Synchronize new client with past events
if ARGV[0]
  IO.copy_stream ARGV[0], pty_m
end

Thread.new do
  loop do
    char = STDIN.getch
    File.open(key_file, 'a') { |f| f.putc char }
    pty_m << char
  end
end

ExitByPipe.join 'kill'
