class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  
  has_many :softwares, dependent: :destroy
  
  scope :ordered, -> { order(:position, :name) }
  
  before_validation :generate_slug
  
  private
  
  def generate_slug
    self.slug = name.parameterize if name.present?
  end
end
