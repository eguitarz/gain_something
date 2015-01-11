class DeleteThirPartyIdFromResource < ActiveRecord::Migration
  def change
    remove_column :resources, :third_party_id
  end
end
