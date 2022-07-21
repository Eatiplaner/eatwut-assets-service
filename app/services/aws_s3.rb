class AwsS3
  def presigned_url(resource_id:, resource_type:, file_name:, media_type:)
    return unless file_name
    file_name = file_name.gsub(/\s+/, '') # remove whitespace from the file name.

    signer = Aws::S3::Presigner.new(client: S3_CLIENT)

    key = generate_key(resource_id:, resource_type:, file_name:, media_type:)

    [
      signer.presigned_url(
        :put_object,
        bucket: S3_BUCKET,
        key:,
        expires_in: 60 * 5, # 5 minutes
      ),
      key
    ]
  end

  def delete_image(key)
    S3_CLIENT.delete_object(
      bucket: S3_BUCKET,
      key:,
    )
  end

  private

  def generate_key(resource_id:, resource_type:, file_name:, media_type:)
    random_file_key = SecureRandom.uuid
    "#{resource_type}/#{resource_id}/#{media_type}/#{random_file_key}-#{file_name}"
  end
end
