class Category < ActiveRecord::Base
  has_many :categorizations
  has_many :nursing_homes, through: :categorizations
  default_scope order("name DESC")
end
