class MediaTracking < ApplicationRecord
  enum(
    status: {
      inprogress: 'inprogress',
      completed: 'completed',
    }.freeze,
    _prefix: true,
  )

  enum(
    storage_type: {
      single: 'single',
      multiple: 'multiple',
    }.freeze,
    _prefix: true,
  )

  RESOURCE_TYPES = %w[user plan]
  MEDIA_TYPES = %w[avatar]

  validates :media_type, :resource_type, :resource_id, :s3_key, :access_url, presence: true

  validates :resource_type, acceptance: { accept: RESOURCE_TYPES }
  validates :media_type, acceptance: { accept: MEDIA_TYPES }

  validates :s3_key, uniqueness: true

  def remove_old_single_medias
    MediaTracking.where.not(s3_key:).where(resource_id:, resource_type:, media_type:).destroy_all
  end

  def rpc_data
    data = attributes.to_h

    data.delete("updated_at")
    data.delete("created_at")

    data
  end
end
