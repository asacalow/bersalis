module Bersalis
  class Connection < EventMachine::Connection
    attr_accessor :client, :parser

    def initialize(client)
      self.client = client
      client.connection = self
    end

    def post_init
      self.client.start
    end

    def start
      self.parser = Nokogiri::XML::SAX::PushParser.new(Document.new(self.client))
    end

    def receive_data(data)
      Bersalis.debug("IN: #{data}")
      self.parser << data
    end

    def unbind
      # close the stream
      send_data "</stream:stream>"
    end
  end
end