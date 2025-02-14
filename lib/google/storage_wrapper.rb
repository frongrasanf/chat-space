require "google/cloud/storage"

class Google::StorageWrapper
  attr_reader :storage

  def initialize
    @storage = if Rails.env.production?
                  Google::Cloud::Storage.new(project_id: ENV['GOOGLE_PROJECT_ID'])
               else
                  Google::Cloud::Storage.new(project_id: ENV['GOOGLE_PROJECT_ID'], credentials: File.open("./rails-cloud-run.json"))
               end
  end

  def upload_image(file_path, file_name)
    bucket = storage.bucket ENV["GOOGLE_CLOUD_BUCKET_NAME"] || 'chat-space'
    file = bucket.create_file file_path, file_name
  end

  def signed_url(file_name)
    bucket = storage.bucket ENV["GOOGLE_CLOUD_BUCKET_NAME"] || 'chat-space'
    file = bucket.file file_name
    file.signed_url(method: "GET", expires: 60 * 60, issuer: issuer, signing_key: signing_key)
  end

  private

  def issuer
    ENV["GOOGLE_CLOUD_STORAGE_ISSUER"]
  end

  def signing_key
    OpenSSL::PKey::RSA.new(ENV["GOOGLE_CLOUD_STORAGE_PRIVATE_KEY"]&.gsub("\\n", "\n"))
  end
end
