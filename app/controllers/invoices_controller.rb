class InvoicesController < ApplicationController
  before_action :load_invoice, only: [:edit, :update]

  def random
    redirect_to edit_invoice_path(Invoice.order("RANDOM()").first)
  end

  def index
    @invoices = Invoice.all
  end

  def edit
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

  private

  def load_invoice
    return @invoice if @invoice

    serialized = params[:serialized_invoice]

    @invoice = if serialized.present?
      Rails.logger.info "Loading invoice from serialized URI: #{serialized}"
      URI::UID.parse(serialized).decode
    elsif params[:id].present?
      Rails.logger.info "Loading invoice from ID: #{params[:id]}"
      Invoice.includes(:line_items).find(params[:id])
    end

    @invoice
  end

  def serialize_invoice
    options = {
        include_blank: true,
        include_unsaved_changes: true,
        include_descendants: true,
        descendant_depth: 1,
        include_keys: true
      }
    URI::UID.build(@invoice, options).to_s
  end
  helper_method :serialize_invoice
end
