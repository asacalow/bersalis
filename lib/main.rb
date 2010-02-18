require 'rubygems'
require 'eventmachine'

require 'bersalis'

trap(:SIGINT)   { EM.stop }
trap(:SIGTERM)  { EM.stop }

EM.run do
  Bersalis::BasicClient.run
end