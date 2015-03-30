class SurveyOption < ActiveRecord::Base
	acts_as_paranoid # logical deletion!
	#------------------------------- begin accessors ---------------------------------#
  #------------------------------- begin associations ------------------------------#
  #------------------------------- begin module ------------------------------------#
  #------------------------------- begin validations -------------------------------#
  #------------------------------- begin named scopes ------------------------------#
  #------------------------------- begin external libraries ------------------------#
  #------------------------------- begin callback ----------------------------------#
  #------------------------------- begin class methods -----------------------------#
  #------------------------------- begin instance methods --------------------------#
  #def as_json(options = {})
  #  if options == {}
  #    super only: [ :id ], methods: []
  #  else
  #    super options
  #  end
  #end
end
