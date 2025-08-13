class Admin::SoftwaresController < Admin::BaseController
  before_action :find_software, only: [:show, :edit, :update, :destroy, :remove_attachment]
  
  def index
    @categories = Category.all
    
    @softwares = Software.includes(:category, featured_image_attachment: :blob)
    
    # Apply filters
    @softwares = @softwares.where("title ILIKE ?", "%#{params[:search]}%") if params[:search].present?
    @softwares = @softwares.where(category_id: params[:category_id]) if params[:category_id].present?
    
    if params[:status].present?
      case params[:status]
      when 'published'
        @softwares = @softwares.published
      when 'draft'
        @softwares = @softwares.draft
      end
    end
    
    @softwares = @softwares.order(created_at: :desc)
  end
  
  def show
  end
  
  def new
    @software = Software.new
    @categories = Category.all
  end
  
  def create
    @software = Software.new(software_params)
    
    if @software.save
      redirect_to admin_software_path(@software), notice: 'Software created successfully'
    else
      @categories = Category.all
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @categories = Category.all
  end
  
  def update
    if @software.update(software_params)
      redirect_to admin_software_path(@software), notice: 'Software updated successfully'
    else
      @categories = Category.all
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @software.destroy
    redirect_to admin_softwares_path, notice: 'Software deleted successfully'
  end
  
  def remove_attachment
    attachment_id = params[:attachment_id]
    
    # Try to find in screenshots first
    attachment = @software.screenshots.find { |s| s.signed_id == attachment_id }
    attachment ||= @software.install_files.find { |f| f.signed_id == attachment_id }
    
    if attachment
      attachment.purge
      redirect_to edit_admin_software_path(@software), notice: 'Attachment removed successfully'
    else
      redirect_to edit_admin_software_path(@software), alert: 'Attachment not found'
    end
  rescue => e
    redirect_to edit_admin_software_path(@software), alert: "Error removing attachment: #{e.message}"
  end
  
  private
  
  def find_software
    @software = Software.find(params[:id])
  end
  
  def software_params
    params.require(:software).permit(
      :title, :description, :version, :developer, :official_site,
      :file_size, :os_requirements, :published, :category_id,
      screenshots: [], install_files: []
    )
  end
end