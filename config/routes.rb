AppSurvey::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root :to => 'front#index'
  namespace :api do
    # scope :testing, as: 'testing' do
    #   match '/' => 'testing#index', :via => :get
    # end
    scope :v1, module: 'v1', as: 'v1' do
      post 'api_common1' # get common info
    end
  end
  scope module: 'front' do
    match '/403', to: 'errors#error_403', via: :all, as: 'error_403'
    match '/404', to: 'errors#error_404', via: :all, as: 'error_404'
    match '/500', to: 'errors#error_500', via: :all, as: 'error_500'
    match '/503', to: 'errors#error_503', via: :all, as: 'error_503'

  end
end
