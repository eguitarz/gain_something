class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
    	t.string :name
    	t.string :snapshot
    	t.text :description
      t.string :difficulty
    	t.string :pay_method

    	t.belongs_to :user

      t.timestamps
    end
  end
end
