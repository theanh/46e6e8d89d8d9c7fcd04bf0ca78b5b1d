AppSurvey::Application.routes.draw do
  root :to => 'front#index'

  namespace :api do
    scope :v1, module: 'v1', as: 'v1' do
      post 'api_survey1' # attempt survey
      post 'api_survey2' # get survey result
    end
  end
  
  scope module: 'front' do
    match '/403', to: 'errors#error_403', via: :all, as: 'error_403'
    match '/404', to: 'errors#error_404', via: :all, as: 'error_404'
    match '/500', to: 'errors#error_500', via: :all, as: 'error_500'
    match '/503', to: 'errors#error_503', via: :all, as: 'error_503'

    #### SURVEY PATH ####
    get '/survey' => 'contests#survey', as: 'survey'
    get '/survey/result' => 'contests#survey_result', as: 'survey_result'
  end
end
