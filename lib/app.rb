require 'pathname'

App      = OpenStruct.new
App.path = Pathname.new(__dir__).parent
