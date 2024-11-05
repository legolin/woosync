class Supplier < ApplicationRecord
  has_many :imports, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :feeds, dependent: :destroy
end
