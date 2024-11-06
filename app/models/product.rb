class Product < ApplicationRecord
  acts_as_taggable_on :tags
  belongs_to :supplier
end
