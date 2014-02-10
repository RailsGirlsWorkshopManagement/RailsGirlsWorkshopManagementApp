Railsgirls::Application.routes.draw do
  root  'static_pages#home', as: :home

  resources :mail_templates, only: [:edit, :update]

  resources :settings, only: [:edit, :update]

  match '/signout', to: 'sessions#destroy',     via: 'delete'
  get '/success_reg' => 'registrations#success_reg', as: :success_reg
  get '/admin' => 'sessions#new', as: :admin
  resources :sessions, only: [:new, :create, :destroy]

  get '/registrations/new_coach' => 'registrations#new_coach', as: :new_coach
  post 'registrations/accept_registrations' => 'registrations#accept_registrations'
  post 'registrations/comment_registrations' => 'registrations#comment_registrations'
  get 'registrations/:id/cancel' => 'registrations#cancel', as: :cancel
  resources :registrations, :except => [:edit, :show]


  get 'workshops/:id/publish' => 'workshops#publish', as: :publish_workshop
  get 'workshops/:id/unpublish' => 'workshops#unpublish', as: :unpublish_workshop
  post 'workshops/:id/addForm' => 'workshops#addForm'
  post 'workshops/:id/manual_mail_send' => 'workshops#manual_mail_send'
  get 'workshops/:id/manual_mail_show' => 'workshops#manual_mail_show', as: :workshops_manual_mail_show
  resources :workshops, :except => [:show]

  get 'forms/new' => 'forms#new', as: :new_form # type als get param?
  get 'forms/:id' => 'forms#show', as: :coach_form
  get 'forms/:id' => 'forms#show', as: :participant_form
  resources :forms
end
