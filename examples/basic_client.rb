$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'bersalis'

trap(:SIGINT)   { EM.stop }
trap(:SIGTERM)  { EM.stop }

EM.run do
  Bersalis::BasicClient.run
end