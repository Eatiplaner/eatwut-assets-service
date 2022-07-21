class AddMediaTracking < ActiveRecord::Migration[7.0]
  def change
    create_table :media_trackings do |t|
      t.string :media_type, null: false
      t.string :resource_type, null: false
      t.string :resource_id, null: false

      t.string :s3_id, null: false, index: { unique: true }

      t.string :status, null: false, default: 'pending'

      t.index %i[resource_type resource_id]

      t.timestamps
    end
  end
end
