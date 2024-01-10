# frozen_string_literal: true

class InvoiceReflex < ApplicationReflex
  def add_line
    invoice.line_items << invoice.line_items.build(id: line_item_id)
    invoice.calculate_amounts
    revalidate_invoice
  end

  def delete_line
    find_line_item&.mark_for_destruction
    invoice.calculate_amounts
    revalidate_invoice
  end

  def line_changed
    find_line_item&.assign_attributes(permitted_line_params)
    invoice.calculate_amounts
    revalidate_invoice
  end

  private

  def invoice = controller.load_invoice

  def line_item_id
    @line_item_id ||= element.dataset.line_item_id || SecureRandom.uuid
  end

  def find_line_item
    @line_item ||= invoice.line_items.select { |li| li.id == line_item_id }.first
  end

  def permitted_line_params
    params.require(:invoice).require(:line_items).require(line_item_id).permit(:description, :price, :quantity, :discount_percentage)
  end

  def revalidate_invoice
    # revalidate the invoice only if it previously had errors
    invoice.valid? if params[:error_count].to_i > 0
  end
end
