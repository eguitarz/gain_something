class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
    	t.string :name
    	t.text :description
    	t.string :video_id
    	t.boolean :approved

      t.timestamps
    end
  end
end