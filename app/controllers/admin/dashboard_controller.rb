class Admin::DashboardController < Admin::BaseController
  def index
    @stats = {
      total_softwares: Software.count,
      published_softwares: Software.published.count,
      total_categories: Category.count,
      total_downloads: Download.count,
      recent_downloads: Download.includes(:software).limit(10).order(created_at: :desc),
      popular_softwares: Software.published.order(downloads_count: :desc).limit(5),
      recent_softwares: Software.order(created_at: :desc).limit(5)
    }
  end
end