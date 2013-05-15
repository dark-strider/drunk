# encoding: utf-8
class MenuUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  storage :file

  def store_dir
    "uploads/#{mounted_as}/#{model.place_id.to_s}"
  end

  def default_url
    asset_path('/assets/menu/' + [version_name, 'menu.jpg'].compact.join('_'))
  end

  version :normal do
    process resize_to_fit: [60, 60]
  end

  def extension_white_list
    %w(jpg jpeg png)
  end

  def filename
     "#{secure_token(16)}.#{file.extension}" if original_filename.present?
  end

protected

  def secure_token(length=16)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end
end
