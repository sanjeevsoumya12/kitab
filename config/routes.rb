Rails.application.routes.draw do
  devise_for :users, controllers: {
                       sessions: "users/sessions",
                       registrations: "users/registrations",
                       passwords: "users/passwords",
                     }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :authors, only: [:index, :create]
    resources :books
  end
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
