class Invoice < ApplicationRecord
  monetize :total_cents
  monetize :balance_cents

  has_many :line_items, dependent: :destroy, inverse_of: :invoice, autosave: true

  before_validation :calculate_amounts
  before_save :calculate_amounts

  def calculate_amounts
    line_items.each(&:calculate_total)
    self.total_cents = line_items.map(&:total_cents).map(&:to_i).sum
    self.balance = total # TODO: payments
  end
end
