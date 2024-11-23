module Connectors
  module Woo
    module Models
      class Base
        include ActiveModel::API
        include ActiveModel::Attributes

        class UpdateError < StandardError; end
        class GetError < StandardError; end
        class NotFoundError < StandardError; end

        def self.connection= connection
          @@connection = connection
        end

        def self.connection
          @@connection
        end

        def connection
          @@connection
        end
      end
    end
  end
end
