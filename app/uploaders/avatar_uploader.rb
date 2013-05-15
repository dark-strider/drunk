# encoding: utf-8
class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  storage :file

  def store_dir
    "uploads/#{mounted_as}/#{model.id}"
  end

  def default_url
    asset_path('/assets/avatar/' + [version_name, 'avatar.jpg'].compact.join('_'))
  end

  version :large do
    process resize_to_limit: [300, 300]
  end

  version :normal, from_version: :large do
    process resize_to_fit: [60, 60]
  end

  version :small, from_version: :normal do
    process resize_to_fit: [27, 27]
  end

  def extension_white_list
    %w(jpg jpeg png)
  end

  def filename
    'avatar.jpg' if original_filename
  end
end
