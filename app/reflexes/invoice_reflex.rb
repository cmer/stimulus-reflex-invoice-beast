# frozen_string_literal: true

class InvoiceReflex < ApplicationReflex
  def add_line
    Rails.logger.info "Adding line..."

    line_item = invoice.line_items.build

    selector = dom_id(invoice, :items)
    html = render(LineItemRowComponent.new(line_item))
    cable_ready.append(selector:, html:)

    future.added(line_item)
    log_future_details

    update_totals
  end

  def delete_line
    Rails.logger.info "Deleting line: #{element.dataset.line_item_id}"

    cable_ready.remove(selector: row_id)
    future.removed(element.dataset.line_item_id)
    log_future_details

    update_totals
  end

  def line_changed
    Rails.logger.info "Line changed: #{element.dataset.line_item_id}"

    li_params = line_item_params(element.dataset.line_item_id)
    line_item = invoice.line_items.build(li_params)
    line_item.id = element.dataset.line_item_id
    line_item.calculate_total

    # Check if line item was previously validated when a form post was attempted.
    # If so, we want to re-validate it every time the line item changes in order
    # to live-update the form's validation errors. ie: remove the red border when
    # the field becomes valid.
    if future.validated?(line_item)
      line_item.valid?
    end

    html = render(LineItemRowComponent.new(line_item))

    future.changed(element.dataset.line_item_id)
    log_future_details

    morph(row_id, html)
    update_totals
  end

  private

  def row_id = "##{element.dataset.row_id}"

  def invoice
    @invoice ||= Invoice.find(element.dataset[:invoice_id])
  end

  def future
    @future ||= InvoiceFuture.find(element.dataset[:invoice_future_id])
  end

  def line_item_params(line_item_id)
    params.dig(:invoice, :line_items, line_item_id)&.permit(:description, :quantity, :price, :discount_percentage) || {}
  end

  def log_future_details
    text = "Added: #{future.added_items.join(', ')}\nChanged: #{future.changed_items.join(', ')}\nRemoved: #{future.removed_items.join(', ')}"
    Rails.logger.info "Future details: #{text}"
    cable_ready.console_log(message: text)
  end

  def update_totals
    invoice_from_params = Invoice.from_future_params(future, params)
    invoice_from_params.calculate_amounts

    html = render(InvoiceTotalComponent.new(invoice_from_params))
    selector = dom_id(invoice_from_params, :total)

    morph(selector, html)
  end
end