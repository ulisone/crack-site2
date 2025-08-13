class Download < ApplicationRecord
  belongs_to :software, counter_cache: :downloads_count
  
  validates :ip_address, presence: true
  validates :user_agent, presence: true
  
  scope :recent, -> { order(created_at: :desc) }
  scope :today, -> { where(created_at: Date.current.all_day) }
  scope :this_week, -> { where(created_at: 1.week.ago..Time.current) }
end
