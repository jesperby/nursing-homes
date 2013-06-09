class TypeOfToCategory < ActiveRecord::Migration
  def up
    NursingHome.all.each do |n|
      n.category_ids = [1] if n.type_of == "nursing_home"
      n.category_ids = [2] if n.type_of == "nursing_home_dementia"
    end

    remove_index  :nursing_homes, :column => :type_of
    remove_column :nursing_homes, :type_of
  end
end
