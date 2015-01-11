class AddVisibilityToCollcetion < ActiveRecord::Migration
  def change
    add_column :collections, :is_visible, :bool, null: false, default: true
  end
end
