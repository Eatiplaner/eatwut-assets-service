class VerifyMediaTrackingUploadStatus < ActiveJob::Base
  # Set the Queue as Default
  queue_as :default

  def perform(tracking_id)
    media_tracking = MediaTracking.find(tracking_id)
    return if media_tracking.status_completed?

    media_tracking.destroy!
  end
end
