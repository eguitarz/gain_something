class ChangeTitleNotNullInResource < ActiveRecord::Migration
  def change
    change_column :resources, :title, :string, null: false, limit: 255
  end
end
