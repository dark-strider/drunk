Drink::Application.routes.draw do
  root to: 'pages#home'
  mount RailsAdmin::Engine => '/dashboard', as: 'rails_admin'

  def albums
    resources :albums do
      get :wall, on: :collection
    end
  end

  devise_for :users, controllers: { registrations: :signup,
                                    omniauth_callbacks: :omniauth_callbacks }
  resources :services, only: :destroy

  resources :users, only: [:index, :show] do
    albums
    resources :friends, only: [:index, :new, :edit, :destroy]
    resources :messages
    get :events, path: 'drinks', on: :member
  end
  # match 'profile' => 'users#show'

  resources :events, path: 'drinks' do
    albums
    get :join, :unjoin, on: :member
  end

  resources :places do
    albums
    resources :news
    resources :menus, except: :show
    resources :reviews
    get :events, path: 'drinks', on: :member
  end

  resources :invites, except: :index do
    get :accept, :refuse
  end

  resources :comments, except: [:index, :show]
  resources :photos, only: [:create, :destroy]

  namespace :searches do
    get :places, :users, :events
  end

  namespace :maps do
    get :my_all, :my_likes
    get :places_all
    get :live_fof, :ready_fof
    get :live_all, :ready_all
    get :live_friends, :ready_friends
  end

  # likes
    post 'likes/:resource_name/:resource_id' => 'likes#like',   as: 'like'
  delete 'likes/:resource_name/:resource_id' => 'likes#unlike', as: 'like'
    post 'dislikes/:resource_name/:resource_id' => 'likes#dislike',   as: 'dislike'
  delete 'dislikes/:resource_name/:resource_id' => 'likes#undislike', as: 'dislike'
end
