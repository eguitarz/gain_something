class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :name, null: false
      t.string :snapshot
      t.text :description

      t.belongs_to :user
      t.timestamps
    end
  end
end
