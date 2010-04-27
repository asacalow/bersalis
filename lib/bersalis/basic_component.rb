module Bersalis
  class BasicComponent < Client
    START_STREAM = "<stream:stream to=\"trousers.alakazam.local\" xmlns=\"jabber:component:accept\" xmlns:stream=\"http://etherx.jabber.org/streams\">"
    PORT_NUMBER = 5275
    
    handle ComponentAccept, :handle_component_accept
    
    def handle_component_accept(component_accept)
      puts "Hurrah!"
    end
  end
end