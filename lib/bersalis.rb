require 'logger'
require 'digest'
require 'eventmachine'
require 'nokogiri'

module Bersalis
  VERSION = '0.2'
  
  def self.logger
    @logger ||= Logger.new($stdout)
  end
  
  def self.info(msg)
    logger.log(Logger::INFO, msg)
  end

  def self.debug(msg)
    logger.log(Logger::DEBUG, msg)
  end
  
  KNOWN_STANZAS = {}
end

require 'bersalis/client'
require 'bersalis/connection'
require 'bersalis/document'
require 'bersalis/node'
require 'bersalis/stanzas/read_only_stanza'
require 'bersalis/stanzas/stanza'
require 'bersalis/stanzas/core/iq'
require 'bersalis/stanzas/core/message'
require 'bersalis/stanzas/core/presence'
require 'bersalis/stanzas/auth/auth'
require 'bersalis/stanzas/auth/auth_mechanism'
require 'bersalis/stanzas/auth/plain_auth'
require 'bersalis/stanzas/auth/digest_auth'
require 'bersalis/stanzas/auth/digest_auth_challenge'
require 'bersalis/stanzas/auth/digest_auth_challenge_response'
require 'bersalis/stanzas/auth/anonymous_auth'
require 'bersalis/stanzas/auth/auth_successful'
require 'bersalis/stanzas/session/session'
require 'bersalis/stanzas/session/bind'
require 'bersalis/stanzas/session/start_tls'
require 'bersalis/stanzas/session/start_tls_proceed'
require 'bersalis/stanzas/session/features'
require 'bersalis/stanzas/roster/roster_get'
require 'bersalis/stanzas/disco/disco_info'
require 'bersalis/stanzas/disco/disco_items'
require 'bersalis/basics'
