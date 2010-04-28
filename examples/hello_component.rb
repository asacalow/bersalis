$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'bersalis'

include Bersalis

trap(:SIGINT)   { EM.stop }
trap(:SIGTERM)  { EM.stop }

EM.run do
  client = BasicComponent.new(:secret => 'b0nnggg!')
  client.connect
end