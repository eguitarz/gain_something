class ChangeEmbeddedHtmlTypeInResources < ActiveRecord::Migration
  def change
  	change_column :resources, :embedded_html, :text
  end
end
