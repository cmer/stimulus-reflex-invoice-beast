Rails.application.routes.draw do
  resources :invoices, only: [:index, :edit, :update]
  root "invoices#random"
end
