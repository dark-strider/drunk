# encoding: utf-8
class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.photographic_type.to_s.underscore}/#{model.photographic_id.to_s}"
  end

  version :large do
    process resize_to_fit: [280, 280]
  end

  version :normal, from_version: :large do
    process resize_to_fit: [100, 100]
  end

  version :small, from_version: :normal do
    process resize_to_fit: [40, 40]
  end

  def extension_white_list
    %w(jpg jpeg png)
  end

  def filename
     "#{secure_token(16)}.#{file.extension}" if original_filename.present?
  end

protected

  def secure_token(length=16)
    # Хранить в бд токен как поле.
    # model.image_secure_token ||= SecureRandom.hex(length / 2)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end
end
