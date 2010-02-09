require 'rubygems'
require 'eventmachine'

require 'stanzas'
require 'guts'

trap(:SIGINT)   { EM.stop }
trap(:SIGTERM)  { EM.stop }

class BasicClient < Client
  handle Features,                  :ready_to_authenticate,     :filter => '/features/auth:auth', :filter_ns => {'auth' => 'http://jabber.org/features/iq-auth'}
  handle AuthenticationSuccessful,  :authentication_successful
  handle Features,                  :ready_to_bind,             :filter => '/features/bind:bind', :filter_ns => {'bind' => 'urn:ietf:params:xml:ns:xmpp-bind'}
  handle Bind,                      :bound
  handle Session,                   :session_started
  
  def ready_to_authenticate(features)
    auth = PlainAuth.create
    auth.set_credentials(:jid => 'jimjam@alakazam.local', :username => 'jimjam', :password => 'password')
    write auth
  end
  
  def authentication_successful(auth_success)
    self.start # we start a new xml document now
  end
  
  def ready_to_bind(features)
    puts "Ready to bind…"
    bind = Bind.create(:type => 'get', :jid => 'jimjam@alakazam.local', :resource => 'trousers')
    write bind
  end
  
  def bound(bind)
    write Session.create(:type => 'set')
  end
  
  def session_started(session)
    write Presence.create
  end
end

EM.run do
  BasicClient.run
end