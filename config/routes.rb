SuperpacappApi::Application.routes.draw do

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

  #resources :committees, :has_many => :ad
  match 'committees'  => 'committee#index', :has_many => :ad
  match 'committees/preview' => 'committee#preview'
  match 'committees/filter' => 'committee#filter'
  match 'committees/newsweek' => 'committee#newsweek'
  match 'committees/:cmte_id'  => 'committee#show'

  match 'ads'  => 'ad#index'
  match 'ads/now' => 'ad#now'
  match 'ads/newsweek' => 'ad#newsweek'
  match 'ads/failed' => 'failed_ad#create'
  match 'ads/map' => 'ad#map'
  match 'ads/failed/list' => 'failed_ad#index'
  match 'ads/:id'  => 'ad#show'
  match 'ads/tunesat/:uuid' => 'ad#tunesat'

  match 'ads/:ad_id/tag'  => 'tagged_ad#create'

  match 'contact'  => 'contact#create'

  match 'appcontact' => 'appcontact#create'

  match 'contacts' => 'contact#index'

  match '/download' => redirect('http://itunes.apple.com/us/app/super-pac-app/id552140731?ls=1&mt=8')

  #match 'appcontacts' => 'appcontact#index'

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
