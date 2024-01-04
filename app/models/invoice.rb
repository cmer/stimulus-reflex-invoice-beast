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

  def to_encrypted_s
    options = {
      include_blank: true,
      include_unsaved_changes: true,
      include_descendants: true,
      descendant_depth: 1,
      include_keys: true
    }
    str = URI::UID.build(self, options).to_s
    ActiveSupport::MessageEncryptor.new(Invoice.encryption_key).encrypt_and_sign(str)
  end

  class << self
    def from_encrypted_s(str)
      decrypted = ActiveSupport::MessageEncryptor.new(encryption_key).decrypt_and_verify(str)
      obj = URI::UID.parse(decrypted).decode
      raise ArgumentError, "Invalid UID. Not an invoice! It is: #{obj.class}" unless obj.is_a?(Invoice)
      obj
    end

    def encryption_key
      @encryption_key ||= ActiveSupport::KeyGenerator.new(Rails.application.credentials.secret_key_base).generate_key(name, 32)
    end
  end
end
