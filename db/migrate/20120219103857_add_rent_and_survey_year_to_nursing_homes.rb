class AddRentAndSurveyYearToNursingHomes < ActiveRecord::Migration
  def change
    change_table :nursing_homes do |t|
      t.integer :rent
      t.integer :survey_year
    end
  end
end
