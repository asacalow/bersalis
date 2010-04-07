$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'bersalis'
include Bersalis

trap(:SIGINT)   { EM.stop }
trap(:SIGTERM)  { EM.stop }

class EchoBot < BasicClient
  handle Message, :handle_message
  
  def handle_message(msg)
    msg.reply!
    write msg
  end
end

EM.run do
  client = EchoBot.new(:jid => 'jimjam@alakazam.local', :password => 'password')
  client.connect
end