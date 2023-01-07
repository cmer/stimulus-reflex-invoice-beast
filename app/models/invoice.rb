class Invoice < ApplicationRecord
  monetize :total_cents
  monetize :balance_cents

  has_many :line_items, dependent: :destroy, inverse_of: :invoice, autosave: true

  before_validation :calculate_amounts
  before_save :calculate_amounts

  def calculate_amounts
    line_items.each(&:calculate_total)
    self.total_cents = line_items
      .reject(&:marked_for_destruction?)
      .map(&:total_cents).map(&:to_i).sum
    self.balance = total # TODO: payments
  end

  class << self
    def from_future_params(invoice_future, params)
      invoice = preload(:line_items).find(params[:id])

      invoice_future.added_items.each do |line_item_id|
        new_line_item = invoice.line_items.build(line_item_params(params, line_item_id))
        new_line_item.id = line_item_id
      end

      invoice.line_items.each do |line_item|
        if line_item.empty_line? || invoice_future.removed?(line_item)
          line_item.mark_for_destruction
        elsif invoice_future.changed?(line_item)
          line_item.assign_attributes(line_item_params(params, line_item.id))
        end
      end

      invoice
    end

    def line_item_params(params, line_item_id)
      params.dig(:invoice, :line_items, line_item_id.to_s)&.permit(
        :description, :price, :quantity, :discount_percentage
      )
    end
  end
end
