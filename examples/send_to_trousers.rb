$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'bersalis'

include Bersalis

trap(:SIGINT)   { EM.stop }
trap(:SIGTERM)  { EM.stop }

class SendToTrousers < BasicClient
  handle Message, :handle_message
  
  def session_started(session)
    write Presence.create
    m = Message.create(:to => 'trousers.alakazam.local', :body => 'Ping!')
    write m
  end
end

EM.run do
  client = SendToTrousers.new(:jid => 'jimjam@alakazam.local', :password => 'password')
  client.connect
end