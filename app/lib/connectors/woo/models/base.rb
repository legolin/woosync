module Connectors
  module Woo
    module Models
      class Base
        include ActiveModel::API
        include ActiveModel::Attributes
        include ActiveModel::Dirty
        include ActiveModel::Serialization

        # By default, send all defined attributes when POSTing
        def attributes_for_post
          attributes.slice(*self.attribute_names).compact
        end

        def apply_api_response(res)
          self.attributes = res.slice(*self.attribute_names)
          changes_applied
        end

        def self.from_api_response(res)
          new.tap do |obj|
            obj.apply_api_response(res)
          end
        end

        def to_h(**options)
          serializable_hash(**options)
        end
      end
    end
  end
end
