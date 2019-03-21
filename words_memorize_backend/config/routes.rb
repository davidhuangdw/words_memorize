Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :words do
    collection do
      get 'recommend'
    end
  end

  resources :memos do
    collection do
      post 'add_test'
    end
  end
end
