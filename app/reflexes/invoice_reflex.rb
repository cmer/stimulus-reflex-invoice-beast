# frozen_string_literal: true

class InvoiceReflex < ApplicationReflex
  def add_line
    Rails.logger.info "Adding line..."

    line_item = invoice.line_items.build
    line_item.id = Time.now.to_i + rand(100000) # need a unique id for the form

    selector = dom_id(invoice, :items)
    html = render(LineItemRowComponent.new(line_item))
    cable_ready.append(selector:, html:)

    future.added(line_item)
    log_future_details

    update_totals
    morph :nothing # prevents a page reload
  end

  def delete_line
    Rails.logger.info "Deleting line: #{element.dataset.line_item_id}"

    cable_ready.remove(selector: row_id)
    future.removed(element.dataset.line_item_id)
    log_future_details

    update_totals
    morph :nothing # prevents a page reload
  end

  def line_changed
    Rails.logger.info "Line changed: #{element.dataset.line_item_id}"

    li_params = line_item_params(element.dataset.line_item_id)
    line_item = invoice.line_items.build(li_params)
    line_item.id = element.dataset.line_item_id
    line_item.calculate_total

    # Call Morph on `cable_ready` directly because the Stimulus Reflex `morph` method doesn't
    # handle `tr` elements without `table` well. This causes the entire innerHTML to be replaced,
    # rather than the node being morphdom'd.
    html = render(LineItemRowComponent.new(line_item, omit_outer_element: true))
    cable_ready.morph(
      children_only: true,
      selector: row_id,
      html: html
    )

    future.changed(element.dataset.line_item_id)
    log_future_details

    update_totals
    morph :nothing # prevents a page reload
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
    params[:invoice][:line_items][line_item_id].permit(:description, :quantity, :price, :discount_percentage)
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
    cable_ready.morph(selector:, html:)
  end
end