require 'optparse'
module Options
  def self.parse!
    default_key_file = File.join(__dir__, '../', 'tmp/keys')
    options = OpenStruct.new  key_file: default_key_file.to_s, key_port: 2001,
                     registration_port: 2000,                    vim_rc: File.expand_path('~/.vimrc')

    OptionParser.new do |opts|
      opts.on("-f", "--key_file=val",           String) { |arg| options.key_file          = arg }
      opts.on("-p", "--key_port=val",          Integer) { |arg| options.key_port          = arg }
      opts.on("-r", "--registration_port=val", Integer) { |arg| options.registration_port = arg }
      opts.on("-c", "--vim_rc=val",             String) { |arg| options.vim_rc            = arg }
      opts.on("-h", "--help")                           { exec "more #{__FILE__}"               }
    end.parse!
    options
  end
end
