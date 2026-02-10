class Quote < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  scope :ordered, -> { order(id: :desc) }
end
