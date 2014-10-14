class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
    	t.string :name
    	t.text :description
    	t.string :pay_method

      t.timestamps
    end
  end
end
