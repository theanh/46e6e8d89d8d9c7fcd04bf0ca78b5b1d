class SurveyAttempt < ActiveRecord::Base
	acts_as_paranoid # logical deletion!
end