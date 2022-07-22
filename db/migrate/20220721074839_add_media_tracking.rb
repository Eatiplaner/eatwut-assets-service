class AddMediaTracking < ActiveRecord::Migration[7.0]
  def change
    create_table :media_trackings do |t|
      t.string :media_type, null: false
      t.string :resource_type, null: false
      t.bigint :resource_id, null: false
      t.string :access_url, null: false

      t.string :s3_key, null: false, index: { unique: true }

      t.string :status, null: false, default: 'inprogress'

      t.index %i[resource_type resource_id media_type], unique: true, name: :index_unique_resource_on_media_type

      t.timestamps
    end
  end
end
