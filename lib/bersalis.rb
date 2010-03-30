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

require 'guts/client'
require 'guts/connection'
require 'guts/document'
require 'guts/node'
require 'stanzas/base/read_only_stanza'
require 'stanzas/base/stanza'
require 'stanzas/core'
require 'stanzas/auth'
require 'stanzas/session'
require 'stanzas/roster'
require 'stanzas/disco'
require 'basics'