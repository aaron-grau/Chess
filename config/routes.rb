Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    resource :play, only: [:new, :show]
  end
end
