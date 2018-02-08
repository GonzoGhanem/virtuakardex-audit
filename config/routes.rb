Rails.application.routes.draw do

  defaults format: :json do
    resources :logs
  end

end
