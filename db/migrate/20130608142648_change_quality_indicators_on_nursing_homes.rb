class ChangeQualityIndicatorsOnNursingHomes < ActiveRecord::Migration
  def up
    add_column :nursing_homes, :quality_average, :integer
    add_column :nursing_homes, :quality_consideration, :integer
    remove_column :nursing_homes, :quality_influence
  end
  def down
    remove_column :nursing_homes, :quality_average
    remove_column :nursing_homes, :quality_consideration
    add_column :nursing_homes, :quality_influence, :integer
  end
end
