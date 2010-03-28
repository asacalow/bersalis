$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'bersalis'

trap(:SIGINT)   { EM.stop }
trap(:SIGTERM)  { EM.stop }

EM.run do
  client = Bersalis::BasicClient.new(:jid => 'jimjam@alakazam.local', :password => 'password')
  client.connect
end