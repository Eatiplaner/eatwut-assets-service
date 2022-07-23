class ChangeIndexMediaTracking < ActiveRecord::Migration[7.0]
  def change
    remove_index :media_trackings, %i[resource_type resource_id media_type], unique: true
    add_index :media_trackings, %i[resource_type resource_id media_type s3_key], unique: true,
name: :index_unique_resource_on_media_type
  end
end
