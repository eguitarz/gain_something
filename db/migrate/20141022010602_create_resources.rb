class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.belongs_to :course
    	t.string :title
    	t.string :mime
    	t.text :description
    	t.string :url
    	t.integer :priority

      t.timestamps
    end
  end
end
