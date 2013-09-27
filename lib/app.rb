require 'pathname'

require_relative 'options'

App         = OpenStruct.new
App.path    = Pathname.new(__dir__).parent
App.options = Options.parse!
