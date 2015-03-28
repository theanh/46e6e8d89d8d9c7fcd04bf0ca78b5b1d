class User < ActiveRecord::Base
	acts_as_paranoid # logical deletion!
  has_surveys
end