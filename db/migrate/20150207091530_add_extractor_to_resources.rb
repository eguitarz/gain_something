class AddExtractorToResources < ActiveRecord::Migration
  def change
    add_column :resources, :extractor, :string
  end
end
