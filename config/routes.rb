FullcalendarMasterRails3::Application.routes.draw do

  resources :attachments do
    get "serve", :on => :member
  end

  get "download_file" => "attachments#download_file", as: 'download_file'

  resources :information

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :microposts, only: [:new, :create, :destroy]

  match '/home',    to: 'static_pages#home'
  match '/help',    to: 'static_pages#help' 
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'
  match '/roadmap', to: 'static_pages#roadmap'

  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  root :to => 'events#index'

  post  'events/demo_create' => 'events#demo_create'

  get   'events/db_cleanup'    => 'events#db_cleanup', :as => 'db_cleanup'
  get   'events/get_events' => 'events#get_events', :as => 'get_events'
  post  'events/resize'     => 'events#resize'
  post  'events/move'       => 'events#move'

  resources :events

#  get 'events/new' => 'events#new' 
#  post 'events/create' => 'events#create'
#  delete  'events/destroy' => 'events#destroy'
#  get  'events/edit' => 'events#edit'
#  put  'events/update' => 'events#update'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
