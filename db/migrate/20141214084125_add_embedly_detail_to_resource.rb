class AddEmbedlyDetailToResource < ActiveRecord::Migration
  def change
    add_column :resources, :provider_name, :string
    add_column :resources, :provider_url, :string
    add_column :resources, :thumbnail, :string
    add_column :resources, :thumbnail_width, :string
  end
end
