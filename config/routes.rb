Rails.application.routes.draw do
  get 'bookings/create'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :restaurants do
        resources :bookings, only: :create
      end
    end
  end

end
