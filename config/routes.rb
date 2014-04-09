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
        put :set_important
        put :add_comment
        put :update_comment
        put :destroy_comment
        put :to_archive
        put :censored_comment
        put :plus
        get :edit_comment
        put :plus_comment
      end
    end
  end

devise_for :users
match '/project/:project', :to => 'core/projects#to_project'

namespace :core, :shallow => true do
  resources :projects do
    member do
      get :next_stage
      get :pr_stage
    end
  end 
end

scope '/project/:project' do
  get '/article1', :to => 'core/projects#article1'
  get '/article2', :to => 'core/projects#article2'
  get '/article3', :to => 'core/projects#article3'


  namespace :help do
    post :save_help_answer, :to => 'posts#save_help_answer'
    resources :posts
  end
  namespace :knowbase do
    resources :posts
  end
  resources :users do
    get :show_top, :on => :collection
    member do
      put :forecast
      put :forecast_concept
      put :forecast_plan
      match 'add_score/:score' => 'users#add_score'
      match 'add_score_essay/:score' => 'users#add_score_essay'
    end
  end

  namespace :life_tape do
    resources :posts do
      get :vote_top, :on => :collection
      member do
        put :set_one_vote
      end
    end
    posts_routes

  end

  get :autocomplete_discontent_post_whend_discontent_posts , to: 'discontent/posts#autocomplete_discontent_post_whend'
  get :autocomplete_discontent_post_whered_discontent_posts , to: 'discontent/posts#autocomplete_discontent_post_whered'
  post 'discontent/posts/:id/union', to:  'discontent/posts#union_discontent'
  get 'discontent/posts/unions', to:  'discontent/posts#unions'

  namespace :discontent do
    resources :aspects
    posts_routes
    resources :posts do
      member do
        put :remove_union
        put :add_union
        put :status_post
        put :post_note_new
        put :post_note_create
        put :post_note_edit
        put :post_note_update
      end
    end
  end

  namespace :concept do
    posts_routes
  end

  post 'plan/posts/get_cond', to:  'plan/posts#get_cond'
  post 'knowbase/posts/sortable_save', to:  'knowbase/posts#sortable_save'

  namespace :plan do
    posts_routes
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
