class InvoicesController < ApplicationController
  before_action :load_invoice, only: [:edit, :update]

  def random
    redirect_to edit_invoice_path(Invoice.order("RANDOM()").first)
  end

  def index
    @invoices = Invoice.all
  end

  def update
    if @invoice.save
      link_to_invoice = helpers.link_to("Invoice ##{@invoice.invoice_number}", edit_invoice_path(@invoice), class: "underline decoration-sky-300 font-semibold")
      redirect_to invoices_path, notice: "#{link_to_invoice} updated!"
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def load_invoice
    @invoice ||= load_from_serialized || load_from_id
  end

  private

  def load_from_serialized
    return unless params[:serialized_invoice].present?
    Invoice.from_encrypted_s(params[:serialized_invoice])
  end

  def load_from_id
    Invoice.includes(:line_items).find(params[:id])
  end
end
