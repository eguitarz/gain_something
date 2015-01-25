class AddThumbnailHeightToResource < ActiveRecord::Migration
  def change
    add_column :resources, :thumbnail_height, :integer
  end
end
