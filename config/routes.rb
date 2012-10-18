CollectiveMind::Application.routes.draw do
  get "journal/enter"

  resources :tests do
    member do
      put :save_attempt
    end
  end

  resources :projects

  resources :questions do
    resources :answers do
      member do
        put :plus
        put :minus
      end
    end
    member do
      put :plus
      put :minus
    end
  end

  match "/about", :to => "pages#about"
  match "/contacts", :to => "pages#contacts"
  match "/help", :to => "pages#help"
  match "/home", :to => "pages#home"
  match "/donot", :to => "pages#donot"

  match "/signin", :to => "sessions#new"
  match "/signout", :to => "sessions#destroy"
  match "/structure", :to => "pages#structure_frustrations"
  match "/unstructure", :to => "pages#unstructure_frustrations"
  match "/archive", :to => "pages#archive_frustrations"  
  match "/to_expert", :to => "pages#to_expert_frustrations"
  match "/accepted", :to => "pages#accepted_frustrations"  
  match "/declined", :to => "pages#declined_frustrations"    


  #get "users/new"
  resources :users
  resources :sessions, :only => [:new, :create, :destroy]
  resources :frustrations  do      
     
      resources :frustration_comments do
        member do
          put :to_trash_by_admin
        end
      end

      member do
       put :archive
       put :to_expert
       put :expert_accept
       put :expert_accept_with_replacement
       put :expert_decline
       get :edit_to_struct
       get :edit_to_expert
       put :update_to_struct
       put :update_to_expert
       put :to_archive_by_admin
      end
  end
  #match "frustrations/archive/:id/", :to =>"frustrations#archive"
  match "/signup", :to =>"users#new"

  get "welcome/index"
  
  resources :posts do
    resources :comments
  end

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
  root :to => 'pages#accepted_frustrations'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
