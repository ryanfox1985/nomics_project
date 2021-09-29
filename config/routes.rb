# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :currencies, only: [] do
    collection do
      match 'task1', to: 'currencies#task1', via: %i[get post]
      match 'task2', to: 'currencies#task2', via: %i[get post]
      match 'task3', to: 'currencies#task3', via: %i[get post]
      match 'task4', to: 'currencies#task4', via: %i[get post]
    end
  end

  root 'application#home'
end
