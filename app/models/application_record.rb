class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  after_initialize :generate_id

  private

  def generate_id
    self.id ||= SecureRandom.uuid
  end
end
