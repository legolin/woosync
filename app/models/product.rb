require 'dentaku'

class Product < ApplicationRecord
  acts_as_taggable_on :tags
  belongs_to :supplier
  has_many :images

  validate :supplier, :presence
  validate :sku, :presence

  before_save :set_defaults

  after_save :updates_need_sync

  scope :not_archived, ->() { where.not(state: 'archived') }

  state_machine initial: :active do
    state :active
    state :discontinued
    state :archived

    event :discontinue do
      transition active: :discontinued
    end

    event :reactivate do
      transition discontinued: :active
    end

    event :archive do
      transition active: :archived
    end
  end

  def mark_as_synced!
    update_columns(
      needs_sync: false,
      last_synced_at: Time.now
    )
  end

  def availability
    if self.quantity_in_stock > 0
      "In Stock"
    else
      "Out of Stock"
    end
  end

  def estimated_profit_margin
    (1 - ((price) / (listing_price))) * 100.0
  end

  # Given the supplier's price_calculation_rule,
  # interpolate values from this product and return the result.
  def generated_price
    return nil unless supplier.price_calculation_rule

    calculator = Dentaku::Calculator.new
    calculator.store(
      price: price,
      msrp: msrp,
      shipping_cost: shipping_cost
    )
    calculator.evaluate(supplier.price_calculation_rule).to_d.truncate(2)
  end

  # Given an array of image URLs, update the list of associated images for this
  # object.
  def image_list=array
    puts array.inspect
    existing = images.pluck(:url)
    new_entries = array - existing
    to_delete = existing - array
    images.select{ _1.url == to_delete }.each(&:destroy)
    new_entries.each do |url|
      self.images.build(url: url)
    end
  end

  def listing_price
    generated_price || msrp
  end

  def destroy
    update(state: 'discontinued')
  end

  private

  # If no in-stock entry is provided, set the quantity to 0
  def set_defaults
    self.quantity_in_stock ||= 0
  end

  def updates_need_sync
    changed_columns = previous_changes.keys - %w[updated_at last_synced_at needs_sync]
    update_column(:needs_sync, self.needs_sync || changed_columns.any?)
  end
end
