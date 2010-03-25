require 'logger'
require 'digest'
require 'rubygems'
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
end

require 'guts'
require 'stanzas'
require 'stanzas/core'
require 'stanzas/auth'
require 'stanzas/session'
require 'stanzas/roster'
require 'basics'