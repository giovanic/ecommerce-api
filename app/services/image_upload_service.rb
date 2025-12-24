class ImageUploadService
  def self.upload(file, folder: 'products')
    begin
      result = Cloudinary::Uploader.upload(
        file,
        folder: folder,
        transformation: [
          { width: 800, height: 800, crop: :limit },
          { quality: 'auto' },
          { fetch_format: 'auto' }
        ]
      )

      {
        success: true,
        url: result['secure_url'],
        public_id: result['public_id'],
        width: result['width'],
        height: result['height']
      }
    rescue => e
      { success: false, error: e.message }
    end
  end

  def self.upload_multiple(files, folder: 'products')
    files.map { |file| upload(file, folder: folder) }
  end

  def self.delete(public_id)
    begin
      result = Cloudinary::Uploader.destroy(public_id)
      { success: result['result'] == 'ok' }
    rescue => e
      { success: false, error: e.message }
    end
  end

  def self.generate_thumbnail(public_id, width: 200, height: 200)
    Cloudinary::Utils.cloudinary_url(
      public_id,
      width: width,
      height: height,
      crop: :fill,
      gravity: :center
    )
  end
end
