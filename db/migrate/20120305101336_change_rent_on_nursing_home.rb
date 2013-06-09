class ChangeRentOnNursingHome < ActiveRecord::Migration
  def change
    change_column :nursing_homes, :rent, :string
  end
end
