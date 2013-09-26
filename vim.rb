# Be as careful in the beginning…
# Be as careful in the beginning…
# Be as careful in the beginning…
# Be as careful in the beginning…
#:rubyfile <a_file_name>

#VIM::command("rviminfo! tmp/viminfo")
#VIM::command("source    tmp/session.vim")
#b = VIM::Buffer.current

fork do
  at_exit do
    File.unlink('kill') if File.exist?('kill')
  end
  
  loop do
    b = VIM::Buffer.current
    b.append(0, "# Be as careful in the beginning…")
    VIM::command('redraw')
    ##VIM::message(Time.now.inspect)
    #File.open('tmp/output', 'r') do |f|
      #VIM::message f.read
    #end
    sleep 2
    exit if File.exist?('kill')
  end
end
