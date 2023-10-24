require 'sidekiq/web'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  Sidekiq::Web.use ActionDispatch::Cookies
  Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_interslice_session'
  mount Sidekiq::Web => '/sidekiq'

  root "rails/health#show", as: :rails_health_check
  match '*path', via: :all, to: proc { [404, {}, []] }
end
