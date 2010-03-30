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
require 'bersalis/stanzas/base/read_only_stanza'
require 'bersalis/stanzas/base/stanza'
require 'bersalis/stanzas/core'
require 'bersalis/stanzas/auth'
require 'bersalis/stanzas/session'
require 'bersalis/stanzas/roster'
require 'bersalis/stanzas/disco'
require 'bersalis/basics'