class AddStorageTypeToMediaTracking < ActiveRecord::Migration[7.0]
  def change
    add_column :media_trackings, :storage_type, :string, null: false, default: 'single'
  end
end
