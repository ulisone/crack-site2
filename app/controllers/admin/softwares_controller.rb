class Admin::SoftwaresController < Admin::BaseController
  before_action :find_software, only: [:show, :edit, :update, :destroy, :remove_attachment]
  
  def index
    @softwares = Software.includes(:category, featured_image_attachment: :blob)
                        .order(created_at: :desc)
                        .page(params[:page])
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
    attachment = @software.screenshots.find(params[:attachment_id])
    attachment.purge
    redirect_to edit_admin_software_path(@software), notice: 'Attachment removed successfully'
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