class SurveyQuestion < ActiveRecord::Base
	acts_as_paranoid # logical deletion!
end