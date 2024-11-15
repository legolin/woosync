class Supplier < ApplicationRecord
  has_many :imports, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :feeds, dependent: :destroy

  def slug
    read_attribute(:slug).presence || name
  end

  def custom_price?
    price_calculation_rule.present?
  end
end
