module Bersalis
  class BasicClient < Client
    handle Features,                  :choose_auth_mechanism,     :filter => '/features/sasl:mechanisms', :filter_ns => {'sasl' => 'urn:ietf:params:xml:ns:xmpp-sasl'}
    handle StartTLSProceed,           :proceed_with_tls
    handle DigestAuthChallenge,       :auth_challenge
    handle AuthenticationSuccessful,  :authentication_successful
    handle Features,                  :ready_to_bind,             :filter => '/features/bind:bind', :filter_ns => {'bind' => 'urn:ietf:params:xml:ns:xmpp-bind'}
    handle Bind,                      :bound
    handle Session,                   :session_started
    
    def initialize(opts={}, *args)
      super(*args)
      @jid = JID.new(opts[:jid])
      @password = opts[:password]
      @host = opts[:host] || @jid.host
    end
    
    def choose_auth_mechanism(features)
      if features.tls_required?
        write StartTLS.create
        return
      end
      auth = DigestAuth.create
      write auth
    end
    
    def proceed_with_tls(proceed)
      self.start_tls
      self.restart
    end
    
    def auth_challenge(challenge)
      challenge.decode_challenge
      response = DigestAuthChallengeResponse.create
      response.set_credentials(:username => @jid.username, :password => @password, :nonce => challenge.nonce, :realm => challenge.realm, :domain => @host)
      write response
    end

    def authentication_successful(auth_success)
      self.restart # now that we're authenticated we start a new stream
    end

    def ready_to_bind(features)
      bind = Bind.create(:type => 'get', :jid => @jid.bare_jid, :resource => @jid.resource)
      write bind
    end

    def bound(bind)
      write Session.create(:type => 'set')
    end

    def session_started(session)
      write Presence.create
    end
  end
end