CollectiveMind::Application.routes.draw do

  def posts_routes
    get 'vote_list'  => 'posts#vote_list'
    put 'vote/:post_id'  => 'posts#vote'
    get 'censored/:post_id'  => 'posts#censored'
    put 'up/:post_id'  => 'posts#up'
    put 'down/:post_id'  => 'posts#down'
    get 'aspect/:aspect/posts/'  => 'posts#index'

    resources :posts do
      member do
        put :add_comment
        put :censored_comment
        get :plus
        put :plus_comment
      end
    end
  end

devise_for :users

namespace :core, :shallow => true do 
  resources :projects do
    member do
      get :next_stage
      get :pr_stage
    end
  end 
end

scope '/project/:project' do

  namespace :help do
    post :save_help_answer, :to => 'posts#save_help_answer'
    resources :posts
  end

  resources :users do
    member do
      put :forecast
      put :forecast_concept
      put :forecast_plan
      match 'add_score/:score' => 'users#add_score'
      match 'add_score_essay/:score' => 'users#add_score_essay'
    end
  end


  namespace :life_tape do
    posts_routes
  end

  namespace :discontent do
    resources :aspects
    posts_routes
  end

  namespace :concept do
    get 'vote_list'  => 'posts#vote_list'
    put 'vote/:post_id'  => 'posts#vote'
    scope '/status/:status/',  :defaults => {:status => 0} do   
      resources :posts do
            member do
                get :add_aspect
                get :add_new_discontent
                put :add_comment
                put :plus
                put :censored_comment

                put :plus_comment
                put :to_archive
                get :to_expert
                put :to_expert_save  
                get :expert_rejection
                put :expert_rejection_save 
                get :expert_revision
                put :expert_revision_save
                get :expert_acceptance_save
            end
      end
    end
   end  

   namespace :plan do
    get 'vote_list'  => 'posts#vote_list'
    put 'vote/:post_id'  => 'posts#vote'
    scope '/status/:status/',  :defaults => {:status => 0} do   
      resources :posts do
            member do
                get :add_aspect
                get :add_first_cond
                get :add_new_discontent
                put :censored_comment
                put :add_comment
                put :plus
                put :plus_comment
                put :to_archive
                get :to_expert
                put :to_expert_save  
                get :expert_rejection
                put :expert_rejection_save 
                get :expert_revision
                put :expert_revision_save
                get :expert_acceptance_save
            end
      end
    end
   end

  namespace :estimate do
    get 'vote_list'  => 'posts#vote_list'
    put 'vote/:post_id'  => 'posts#vote'
    scope '/status/:status/',  :defaults => {:status => 0} do
      resources :posts do
        member do
          get :add_aspect
          put :censored_comment
          put :add_comment
          put :plus
          put :plus_comment
          put :to_archive
          get :to_expert
          put :to_expert_save
          get :expert_rejection
          put :expert_rejection_save
          get :expert_revision
          put :expert_revision_save
          get :expert_acceptance_save
        end
      end
    end
  end


  
  namespace :expert_news do
    get 'censored/:post_id'  => 'posts#censored'

    resources :posts do    
      member do
          put :add_comment
          put :plus
          put :censored_comment

          put :plus_comment
      end
    end
  end

  scope '/stage/:stage' do
    namespace :essay do
      get 'censored/:post_id'  => 'posts#censored'

      resources :posts do
        member do
          put :add_comment
          put :censored_comment

          put :plus
          put :plus_comment
        end
      end
    end
  end

  namespace :question do
    get 'censored/:post_id'  => 'posts#censored'

    resources :posts do    
      member do
        put :censored_comment

        put :add_comment
          put :plus
          put :plus_comment
      end
    end
  end
  
end


############



  root :to => 'core/projects#index'

end
