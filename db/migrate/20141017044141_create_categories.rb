class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
    	t.string :name
    	t.text :description
    	t.boolean :enabled
      t.timestamps
    end
  end
end
