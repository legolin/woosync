class Feed < ApplicationRecord
  has_many :mappings, dependent: :destroy

  accepts_nested_attributes_for :mappings, allow_destroy: true, reject_if: :all_blank

  validates :title, :feed_type, presence: true
  validates :feed_type, inclusion: { in: %w[update delete] }
end
