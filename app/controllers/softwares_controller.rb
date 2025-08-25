class SoftwaresController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  
  def index
    @softwares = Software.published.includes(:category, featured_image_attachment: :blob)
    
    if params[:category_id].present?
      @current_category = Category.find(params[:category_id])
      @softwares = @softwares.where(category: @current_category)
    end
    
    @softwares = @softwares.recent.limit(20)
  end
  
  def show
    @software = Software.published.find(params[:id])
    @related_softwares = Software.published
                                .where(category: @software.category)
                                .where.not(id: @software.id)
                                .limit(4)
  end
  
  private
  
  def record_not_found
    redirect_to root_path, alert: 'Software not found or not published.'
  end
end