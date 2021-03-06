# encoding: utf-8

class LogoUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  

  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    #"/assets/fallback/" + [version_name, "default.jpg"].compact.join('_')
    ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.jpg"].compact.join('_'))
    #"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  
  version :default         do process :resize_to_fill => [32,32     , 'Center']      end
  version :small           do process :resize_to_fill => [48,48     , 'Center']      end
  version :size_184x184    do process :resize_to_fill => [184,184   , 'Center']      end
  version :size_270x270    do process :resize_to_fill => [270,270   , 'Center']      end
  
  
  
  # Create different versions of your uploaded files:
  #version :default do
  #  #process :resize_to_fit => [200, 113]
  #  #resize_and_pad(340, 96,:transparent,'Center')
  #  #process :convert => 'png'
  #  process :resize_to_fit => [640, 640]
  #end
  #
  #version :small do
  #  #process :resize_to_fit => [200, 113]
  #  #resize_and_pad(170, 48,:transparent,'Center')
  #  #process :convert => 'png'
  #  process :resize_to_fit => [150, 150]
  #end
  #
  #version :size_184x184 do
  #  #process :resize_to_fit => [200, 113]
  #  #resize_and_pad(170, 48,:transparent,'Center')
  #  #process :convert => 'png'
  #  process :resize_to_fit => [184, 184]
  #end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png bmp tif tiff)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
