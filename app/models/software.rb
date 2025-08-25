class Software < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :version, presence: true
  
  belongs_to :category, counter_cache: :softwares_count
  has_many :downloads, dependent: :destroy
  
  # Active Storage attachments
  has_many_attached :screenshots do |attachable|
    attachable.variant :thumb, resize_to_limit: [300, 200]
    attachable.variant :medium, resize_to_limit: [800, 600]
  end
  
  has_many_attached :install_files
  has_one_attached :featured_image
  
  scope :published, -> { where(published: true) }
  scope :draft, -> { where(published: false) }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_category, ->(category) { where(category: category) }
  
  def status
    published? ? 'published' : 'draft'
  end
  
  validate :acceptable_screenshots
  validate :acceptable_install_files
  
  after_save :set_featured_image
  
  private
  
  def acceptable_screenshots
    return unless screenshots.attached?
    
    screenshots.each do |screenshot|
      unless screenshot.blob.content_type.in?(%w[image/jpeg image/png image/webp])
        errors.add(:screenshots, 'must be JPEG, PNG, or WebP')
      end
      
      if screenshot.blob.byte_size > 5.megabytes
        errors.add(:screenshots, 'must be less than 5MB')
      end
    end
  end
  
  def acceptable_install_files
    return unless install_files.attached?
    
    install_files.each do |file|
      if file.blob.byte_size > 500.megabytes
        errors.add(:install_files, 'must be less than 500MB')
      end
    end
  end
  
  def set_featured_image
    if screenshots.attached? && !featured_image.attached?
      featured_image.attach(screenshots.first.blob)
    end
  end
end
