class DownloadsController < ApplicationController
  before_action :find_software_and_file
  before_action :log_download
  
  def show
    @software.increment!(:downloads_count)
    redirect_to rails_blob_path(@attachment, disposition: 'attachment')
  end
  
  private
  
  def find_software_and_file
    @software = Software.published.find(params[:software_id])
    @attachment = @software.install_files.find(params[:id])
  end
  
  def log_download
    Download.create!(
      software: @software,
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      file_name: @attachment.filename.to_s
    )
  end
end