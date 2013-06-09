# -*- coding: utf-8 -*-
class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :short_name

      t.timestamps
    end
    Category.reset_column_information
    Category.create!( name: "Vårdboende", short_name: "Vårdboende" )
    Category.create!( name: "Gruppboende med demensintriktning", short_name: "Demensintriktning" )
  end
end
