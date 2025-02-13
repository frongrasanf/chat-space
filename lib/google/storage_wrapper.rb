require "google/cloud/storage"

class Google::StorageWrapper
  attr_reader :storage

  def initialize
    @storage = Google::Cloud::Storage.new(
      project_id: ENV['GOOGLE_PROJECT_ID'] || '',
      credentials: File.open("./rails-cloud-run.json")
    )
  end

  def upload_image(file_path, file_name)
    bucket = storage.bucket ENV["GOOGLE_CLOUD_BUCKET_NAME"] || 'chat-space'
    file = bucket.create_file file_path, file_name
  end

  def signed_url(file_name)
    bucket = storage.bucket ENV["GOOGLE_CLOUD_BUCKET_NAME"] || 'chat-space'
    file = bucket.file file_name
    file.signed_url method: "GET", expires: 60 * 60
  end
end
