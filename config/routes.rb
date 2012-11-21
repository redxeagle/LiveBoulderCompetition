Bws::Application.routes.draw do


  resource :user do
    get :edit_participant
  end

  resource :user_session
  resource :account, :controller => "users"

  resources :participants do
    get :insert
    post :insert
    post :select
    get :show
  end

  match 'ranking' => 'boulders#ranking'
  match 'boulderer/:id' => 'boulders#show_user'
  match 'insert' => 'participants#insert'

  resources :boulders do
    collection do
      get :grafik
      get :relax
      get :power
      post :relax
      post :power
      get :reload
    end
  end

  root :to => 'participants#insert'

end
