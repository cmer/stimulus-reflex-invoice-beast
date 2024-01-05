class LineItem < ApplicationRecord
  monetize :price_cents
  monetize :total_cents

  belongs_to :invoice, inverse_of: :line_items, touch: true
  before_validation :calculate_total, :assign_defaults, unless: :frozen?

  validates :description, :price, :quantity, presence: true
  validates :price_cents, numericality: { greater_than: 0, only_integer: true }
  validates :quantity, numericality: { greater_than: 0, only_integer: true }
  validates :discount_percentage, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100
  }

  def calculate_total
    q = quantity.to_i
    p = price_cents.to_i
    d = discount_percentage.to_i

    self.total_cents = (q * p) - (q * p * d / 100)
  end


  def assign_defaults
    self.discount_percentage ||= 0
  end
end
