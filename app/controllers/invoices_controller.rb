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
    @invoice_future = InvoiceFuture.find(params[:invoice][:future_id])
    @invoice = Invoice.from_future_params(@invoice_future, params)

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
      @invoice.line_items.each do |line_item|
        line_item.valid? unless line_item.frozen? # This is needed to populate the errors hash
      end
      @invoice.line_items.each(&:save!)
      @invoice.save!
      @invoice_future.destroy!
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
    false
  end
end
