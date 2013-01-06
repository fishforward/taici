Taici::Application.routes.draw do

  resources :authentications

  #resources :comments

  #devise_for :users

  #resources :taiciis

  #resources :stands

  resources :topics

  resources :symbols

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  post "topics" => "topics#create"

  post "love/feel" => "love#feel"
  post "love/no_feel" => "love#no_feel"
  post "love/ding" => "love#ding"
  post "love/cai" => "love#cai"
  #match '/love/feel', :to => 'love#feel'
  #match '/love/no_feel', :to => 'love#no_feel'

  #match 'home' => 'home#index'
  #match 'week' => 'home#week'
  match 'me' => 'home#me'
  match 'top' => 'symbols#top'
  match 'about_symbol' => 'home#about_symbol'

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
  #root :to=>'home#index'
  root :to=>'symbols#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  #devise_for :users do
  #  get '/users/sign_out' => 'devise/sessions#destroy'
  #end

  devise_for :users, :controllers => { :omniauth_callbacks => "authentications", :registrations => "taicii_registrations" } do
    get '/users/sign_out' => 'devise/sessions#destroy'
    get '/users/sign_in' => 'devise/sessions#new'
    #post '/users' => 'taicii_registrations#create'
  end

  ## 错误处理
  match '*path' => proc { |env| Rails.env.development? ? (raise ActionController::RoutingError, %{No route matches "#{env["PATH_INFO"]}"}) : ApplicationController.action(:render_not_found).call(env) }
end
