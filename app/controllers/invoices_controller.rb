class InvoicesController < ApplicationController
  def random
    redirect_to edit_invoice_path(Invoice.order("RANDOM()").first)
  end

  def index
    @invoices = Invoice.all
  end

  def edit
    @invoice = Invoice.preload(:line_items).find(params[:id])
    @invoice_future = InvoiceFuture.create
  end

  def update
    @invoice = Invoice.preload(:line_items).find(params[:id])
    @invoice_future = InvoiceFuture.find(params[:invoice][:future_id])

    if update_invoice_from_params
      link_to_invoice = helpers.link_to("Invoice ##{@invoice.id}", edit_invoice_path(@invoice), class: "underline decoration-sky-300 font-semibold")
      redirect_to invoices_path, notice: "#{link_to_invoice} updated!"
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def update_invoice_from_params
    Invoice.transaction do
      @invoice_future.added_items.each do |line_item_id|
        new_line_item = @invoice.line_items.build(line_item_params(line_item_id))
      end

      @invoice.line_items.each do |line_item|
        if line_item.empty_line? || @invoice_future.removed?(line_item)
          @invoice.line_items.delete(line_item)
        elsif @invoice_future.changed?(line_item)
          line_item.assign_attributes(line_item_params(line_item.id))
        end

        line_item.valid? unless line_item.frozen? # This is needed to populate the errors hash
      end

      @invoice.line_items.each(&:save!)
      @invoice.save!
      @invoice_future.destroy!
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
    false
  end

  def line_item_params(line_item_id)
    params[:invoice][:line_items][line_item_id.to_s].permit(
      :description, :price, :quantity, :discount_percentage
    )
  end
end
