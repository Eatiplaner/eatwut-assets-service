S3_CLIENT = Aws::S3::Client.new(
  region: Rails.application.credentials.aws.fetch(:region),
  access_key_id:        Rails.application.credentials.aws.fetch(:access_key_id),
  secret_access_key:    Rails.application.credentials.aws.fetch(:secret_access_key)
)

S3_BUCKET = Rails.application.credentials.aws.fetch(:bucket_name)
