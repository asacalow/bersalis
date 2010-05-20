module Bersalis
  class BasicComponent < Client
    PORT_NUMBER = 5275
    
    handle ComponentAccept, :handle_component_accept
    handle DiscoInfo,       :handle_disco_info
    
    def initialize(opts={}, *args)
      super(*args)
      @secret = opts[:secret]
      @host = opts[:host]
    end
    
    def start_stream
      "<stream:stream to=\"#{@host}\" xmlns=\"jabber:component:accept\" xmlns:stream=\"http://etherx.jabber.org/streams\">"
    end
    
    def handle_component_accept(component_accept)
      handshake = Handshake.create
      handshake.set_credentials(:id => component_accept.id, :secret => @secret)
      write handshake
    end
    
    def handle_disco_info(disco_info)
      disco_info.reply!
      write disco_info
    end
  end
end