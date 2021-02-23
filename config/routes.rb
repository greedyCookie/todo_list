Rails.application.routes.draw do
  devise_for :users

  resource :user do
    resources :todo_lists, only: %i(index show create update destroy) do
      resources :todo_list_items, only: %i(index show create update destroy)
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
