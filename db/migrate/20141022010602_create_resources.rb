class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.belongs_to :collection
    	t.string :title
      t.string :third_party_id
    	t.string :mime
    	t.text :description
    	t.string :url
    	t.integer :priority

      t.timestamps
    end
  end
end
