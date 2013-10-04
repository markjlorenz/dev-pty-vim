class Promise

  def initialize events
    @events = events
  end

  def on event, lamb
    raise UnknownEvent unless @events.has_key?(event)
    @events[event] << lamb
  end
  
  # Look of a suitable callable in the @events hash
  # else, fail
  def method_missing name, *args
    @events.fetch(name){ super }.each do |lamb|
      lamb[*args] 
    end
  end
  private :method_missing

  UnknownEvent   = Class.new(StandardError)
end

# When including the module, you need to define `@promises` in your
# class.  `@promises` should be a hash of event names, and then an
# array of procs. e.g:
#   ````
#   @promises  = Promise.new connection: [ ->(client){} ]
#   ````
#
# Promises can them be invoked via:
#   ````
#   promises.connection(client)
#   ````
#
# Register additional promises like:
#   ````
#   @registration_server.on :connection, ->(client) {
#     @vim_interface << ":echo 'A new client connected! -- #{client.register_adr}'\n"
#   }
#   ````
module DelegatePromises
  def self.included(base)
    base.instance_eval do
      send :attr_reader, :promises
    end

    def on event, lamb
      promises.on event, lamb
    end

  end
end
