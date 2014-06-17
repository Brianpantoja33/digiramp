class DownloadController < ApplicationController
  #include AccountsHelper
  #before_filter :access_account
  
  def image_file
    @image_file = ImageFile.find(params[:image_file])
    data = open("#{@image_file.file}") 
    mime = @image_file.mime || 'image/jpeg'
    send_data data.read, filename: @image_file.title, type: mime, stream: 'true', buffer_size: '4096'  
  end
  
  def artwork
    @artwork = Artwork.find(params[:artwork])
    data = open("#{@artwork.file}") 
    mime = @artwork.mime || 'image/jpeg'
    send_data data.read, filename: @artwork.title, type: mime, stream: 'true', buffer_size: '4096'  
  end
  
  def financial_document
    begin
      @document= Document.cached_find(params[:document])
      data = open("#{@document.file}") 
      mime = @document.mime || 'image/jpeg'
      send_data data.read, filename: @document.title, type: mime, stream: 'true', buffer_size: '4096'
    rescue
      
    end
  end
  
  def document
    begin
      @document= Document.cached_find(params[:document])
      data = open("#{@document.file}") 
      mime = @document.mime || 'image/jpeg'
      send_data data.read, filename: @document.title, type: mime, stream: 'true', buffer_size: '4096'
    rescue
      
    end
  end

  
end
