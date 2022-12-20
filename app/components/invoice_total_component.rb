# frozen_string_literal: true

class InvoiceTotalComponent < ViewComponent::Base
  attr_reader :invoice

  def initialize(invoice)
    @invoice = invoice
  end

  def paid_amount
    invoice.total - invoice.balance
  end
end
