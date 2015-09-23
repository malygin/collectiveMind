class Util::ImageLoader
  def self.load(param_image)
    if ['image/jpeg', 'image/png'].include? param_image[:image].content_type
      img = Cloudinary::Uploader.upload(param_image[:image], folder: 'comments', crop: :limit, width: 800,
                                                             eager: [{ crop: :fill, width: 150, height: 150 }])
      is_file = false
    else
      img = Cloudinary::Uploader.upload(param_image[:image], folder: 'comments', resource_type: :raw)
      is_file = true
    end
    [img, is_file]
  end
end
