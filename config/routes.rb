CollectiveMind::Application.routes.draw do

  namespace :core do resources :projects end

  namespace :discontent do
   resources :posts do
        member do
            put :add_comment
            put :plus
            put :plus_comment
        end
      end
 end

  namespace :plan do resources :posts end
  namespace :concept do resources :posts end
  namespace :expert_news do resources :posts end

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
  match "/help1", :to => "pages#help1"
  match "/help2", :to => "pages#help2"
  match "/help3", :to => "pages#help3"
  match "/help4", :to => "pages#help4"
  match "/help5", :to => "pages#help5"

  match "/estimate/result", :to => "pages#result"
  match "/home", :to => "pages#home"
  match "/donot", :to => "pages#donot"  
  match "/articles", :to => "pages#articles"

  match "/signin", :to => "sessions#new"
  match "/signout", :to => "sessions#destroy"
  match "/frustrations/structure", :to => "pages#structure_frustrations"
  match "/frustrations/unstructure", :to => "pages#unstructure_frustrations"
  match "/frustrations/archive", :to => "pages#archive_frustrations"  
  match "/frustrations/to_expert", :to => "pages#to_expert_frustrations"
  match "/frustrations/accepted", :to => "pages#accepted_frustrations"  
  match "/frustrations/declined", :to => "pages#declined_frustrations"    
  match "/frustrations/voted", :to => "pages#voted_frustrations"    
  match "/frustrations/show_forecast", :to => "frustrations#show_forecast"    


  #get "users/new"
  resources :users do
    member do
      put :forecast
      put :forecast_concept
      put :forecast_plan
      match 'add_score/:score' => 'users#add_score'
    end
  end

  
  resources :sessions, :only => [:new, :create, :destroy]

  
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
    namespace :life_tape do
      # Directs /admin/products/* to Admin::ProductsController
      # (app/controllers/admin/products_controller.rb)
      get "category/:cat_id" => 'posts#category'
      resources :posts do
        member do
            put :add_comment
            get :new_child
            put :create_child
            put :plus

        end
      end
      resources :comments do
          member do
            put :plus
          end  
      end
    end

    namespace :concept do
      get 'forecast' => "posts#forecast"
      get 'result' => "posts#result"
      get 'essay' => "posts#essay"

      match 'vote_for/:id/:score' => 'posts#vote_for',  :constraints => { :score => /[0-3]/ }

      resources :forecast_tasks
      get 'posts/status/:status_id' => "posts#index"
      resources :posts do
        member do
            put :add_comment
            put :plus
            get :to_expert
            put :to_expert_save  
            get :expert_rejection
            put :expert_rejection_save 
            get :expert_revision
            put :expert_revision_save
            get :expert_acceptance_save
        end
      end
      resources :comments do
          member do
            put :plus
          end  
      end
    end

    namespace :plan do
      get 'forecast' => "posts#forecast"
      # match 'vote_for/:id/:score' => 'posts#vote_for',  :constraints => { :score => /[0-3]/ }

      # resources :forecast_tasks
      get 'posts/status/:status_id' => "posts#index"
      resources :posts do
        member do
            put :add_comment
            put :plus
            get :to_expert
            put :to_expert_save  
            get :expert_rejection
            put :expert_rejection_save 
            get :expert_revision
            put :expert_revision_save
            get :expert_acceptance_save
        end
      end
      resources :comments do
          member do
            put :plus
          end  
      end
    end 
          
    namespace :expert_news do
     
      resources :posts do
        member do
            put :add_comment
            put :plus
        end
      end
      resources :comments do
          member do
            put :plus
          end  
      end
    end

  namespace :estimate do 
     resources :posts do
        member do
            put :add_comment
            put :plus
            get :expert_rejection_save 
            get :expert_rejection_with_penalty_save
            get :expert_acceptance_save
        end
      end
      resources :comments do
          member do
            put :plus
          end  
      end
    match 'vote_for/:id/:score' => 'posts#vote_for',  :constraints => { :score => /[0-3]/ }

    get 'posts/new/:post_id' => "posts#new"
    # get 'vote' => "posts#vote"
    get 'jury' => "posts#jury_index"


  end


  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'pages#result'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
