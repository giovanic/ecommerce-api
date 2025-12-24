class Category < ApplicationRecord
  belongs_to :tenant
  has_many :products, dependent: :nullify

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: { scope: :tenant_id }

  before_validation :generate_slug

  private

  def generate_slug
    self.slug ||= name.to_s.parameterize if name.present?
  end
end
