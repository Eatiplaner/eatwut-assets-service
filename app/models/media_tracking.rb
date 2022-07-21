class MediaTracking < ApplicationRecord
  enum(
    status: {
      pending: 'pending',
      inprogress: 'inprogress',
      completed: 'completed',
    }.freeze,
    _prefix: true,
  )

  RESOURCE_TYPES = %w[user plan]
  MEDIA_TYPES = %w[avatar]

  validates :media_type, :resource_type, :resource_id, :s3_id, presence: true

  validates :resource_type, acceptance: { accept: RESOURCE_TYPES }
  validates :media_type, acceptance: { accept: MEDIA_TYPES }

  validates :s3_id, uniqueness: true
end
