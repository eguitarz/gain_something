class AddEmbeddedHtmlToResource < ActiveRecord::Migration
  def change
  	add_column :resources, :embedded_html, :string
  end
end
