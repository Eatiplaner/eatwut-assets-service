class MediaTracking < ApplicationRecord
  enum(
    status: {
      inprogress: 'inprogress',
      completed: 'completed',
    }.freeze,
    _prefix: true,
  )

  RESOURCE_TYPES = %w[user plan]
  MEDIA_TYPES = %w[avatar]

  validates :media_type, :resource_type, :resource_id, :s3_key, :access_url, presence: true

  validates :resource_type, acceptance: { accept: RESOURCE_TYPES }
  validates :media_type, acceptance: { accept: MEDIA_TYPES }

  validates :s3_key, uniqueness: true

  def rpc_data
    data = attributes.to_h

    data.delete("updated_at")
    data.delete("created_at")

    data
  end
end
