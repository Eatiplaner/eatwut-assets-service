class MediaController < Gruf::Controllers::Base
  bind Asset::MediaService::Service

  def generate_presigned_url
    presigned_url_and_key = aws_s3.presigned_url_and_key(
      **media_payload,
      file_name: request.message.file_name
    )

    presigned_url = presigned_url_and_key[0]
    key = presigned_url_and_key[1]

    media_tracking = MediaTracking.create(
      **media_payload,
      s3_key: key,
      access_url: parse_access_url(presigned_url)
    )

    VerifyMediaTrackingUploadStatus.set(wait: EXPIRED_TIME_PRESIGNED_URL.minutes).perform_later(media_tracking.id)

    Asset::GenerateUrlResp.new(
      presigned_url:,
      key:
    )
  rescue StandardError => e
    set_debug_info(e.message, e.backtrace[0..4])
    fail!(:internal, :internal, "ERROR: #{e.message}")
  end

  def get_media
    media_tracking = MediaTracking.find_by!(**request.message.to_h)
    Asset::GetMediaResp.new(**media_tracking.rpc_data)
  rescue StandardError => e
    set_debug_info(e.message, e.backtrace[0..4])
    fail!(:internal, :internal, "ERROR: #{e.message}")
  end

  def delete_media
    key = request.message.key
    media_tracking = MediaTracking.find_by!(s3_key: key)

    aws_s3.delete_image(key)
    media_tracking.destroy!

    Asset::AcknowledgeResp.new(
      success: true
    )
  rescue StandardError => e
    set_debug_info(e.message, e.backtrace[0..4])
    fail!(:internal, :internal, "ERROR: #{e.message}")
  end

  def acknowledge_uploaded
    key = request.message.key

    MediaTracking.find_by!(s3_key: key).update!(status: MediaTracking.statuses[:completed])

    Asset::AcknowledgeResp.new(
      success: true
    )
  rescue StandardError => e
    set_debug_info(e.message, e.backtrace[0..4])
    fail!(:internal, :internal, "ERROR: #{e.message}")
  end

  private

  def media_payload
    {
      resource_id: request.message.resource_id,
      resource_type: request.message.resource_type,
      media_type: request.message.media_type,
    }
  end

  def parse_access_url(presigned_url)
    presigned_url.split('?').first
  end

  def aws_s3
    AwsS3.new
  end
end
