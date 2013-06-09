class Categorization < ActiveRecord::Base
  belongs_to :category
  belongs_to :nursing_home
end
