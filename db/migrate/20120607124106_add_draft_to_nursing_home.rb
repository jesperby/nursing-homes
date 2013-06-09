class AddDraftToNursingHome < ActiveRecord::Migration
  def change
    add_column :nursing_homes, :draft, :boolean, :default => false
  end
end
