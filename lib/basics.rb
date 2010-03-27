module Bersalis
  class BasicClient < Client
    attr_accessor :jid, :username, :password
    
    handle Features,                  :choose_auth_mechanism,          :filter => '/features/sasl:mechanisms', :filter_ns => {'sasl' => 'urn:ietf:params:xml:ns:xmpp-sasl'}
    #handle Features,                  :ready_to_authenticate,     :filter => '/features/auth:auth', :filter_ns => {'auth' => 'http://jabber.org/features/iq-auth'}
    handle StartTLSProceed,           :proceed_with_tls
    handle DigestAuthChallenge,       :auth_challenge
    handle AuthenticationSuccessful,  :authentication_successful
    handle Features,                  :ready_to_bind,             :filter => '/features/bind:bind', :filter_ns => {'bind' => 'urn:ietf:params:xml:ns:xmpp-bind'}
    handle Bind,                      :bound
    handle Session,                   :session_started
    
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

    def ready_to_authenticate(features)
      auth = DigestAuth.create
      #auth.set_credentials(:jid => 'jimjam@alakazam.local', :username => 'jimjam', :password => 'password')
      write auth
    end
    
    def auth_challenge(challenge)
      challenge.decode_challenge
      response = DigestAuthChallengeResponse.create
      response.set_credentials(:username => 'jimjam', :password => 'password', :nonce => challenge.nonce, :realm => challenge.realm, :domain => 'alakazam.local')
      write response
    end

    def authentication_successful(auth_success)
      self.restart # now that we're authenticated we start a new stream
    end

    def ready_to_bind(features)
      puts "Ready to bind…"
      bind = Bind.create(:type => 'get', :jid => 'jimjam@alakazam.local', :resource => 'trousers')
      write bind
    end

    def bound(bind)
      puts "…bound!"
      write Session.create(:type => 'set')
    end

    def session_started(session)
      write Presence.create
    end
  end
end