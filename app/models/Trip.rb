class Trip < ActiveRecord::Base
  has_many :users
  has_many :flights

end
