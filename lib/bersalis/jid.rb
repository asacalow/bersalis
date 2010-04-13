module Bersalis
  class JID
    attr_accessor :username, :host, :resource
    
    PATTERN = /^(?:([^@]*)@)??([^@\/]*)(?:\/(.*?))?$/.freeze
    
    def initialize(jid_string='')
      @username,@host,@resource = jid_string.scan(PATTERN).first
    end
    
    def to_s
      return host                                   if @username.nil? && @resource.nil?
      return "#{@username}@#{@host}"                if @resource.nil?
      return "#{@username}@#{@host}/#{@resource}"
    end
    
    def bare_jid
      "#{@username}@#{@host}"
    end
  end
end