class SoftwaresController < ApplicationController
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
end