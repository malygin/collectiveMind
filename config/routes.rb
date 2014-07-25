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
        put :set_required
        put :add_child_comment_form
        put :comment_stat
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
  get '/journals', :to => 'journal#index'

  namespace :help do
    post :save_help_answer, :to => 'posts#save_help_answer'
    resources :posts
  end
  namespace :knowbase do
    resources :posts
  end
  resources :users do
    get :show_top, :on => :collection
    get :users_rc, :on => :collection
    member do
      put :forecast
      put :forecast_concept
      put :forecast_plan
      post :update_score
      put :club_toggle
      match 'add_score/:score' => 'users#add_score'
      match 'add_score_essay/:score' => 'users#add_score_essay'
    end
  end
  get 'life_tape/posts/fast_discussion_topics' , to: 'life_tape/posts#fast_discussion_topics'
  put 'life_tape/posts/transfer_comment' , to: 'life_tape/posts#transfer_comment'
  get 'life_tape/posts/check_field', to:  'life_tape/posts#check_field'
  get 'plan/posts/check_field', to:  'plan/posts#check_field'
  get 'estimate/posts/check_field', to:  'estimate/posts#check_field'

  get 'life_tape/posts/to_work', to:  'life_tape/posts#to_work'
  get 'discontent/posts/to_work', to:  'discontent/posts#to_work'
  get 'concept/posts/to_work', to:  'concept/posts#to_work'
  get 'plan/posts/to_work', to:  'plan/posts#to_work'
  get 'estimate/posts/to_work', to:  'estimate/posts#to_work'

  namespace :life_tape do
    posts_routes
    resources :posts do
      get :vote_top, :on => :collection
      member do
        put :set_one_vote
      end
    end

  end

  get :autocomplete_discontent_post_whend_discontent_posts , to: 'discontent/posts#autocomplete_discontent_post_whend'
  get :autocomplete_discontent_post_whered_discontent_posts , to: 'discontent/posts#autocomplete_discontent_post_whered'
  get :autocomplete_concept_post_resource_concept_posts , to: 'concept/posts#autocomplete_concept_post_resource'

  post 'discontent/posts/:id/union', to:  'discontent/posts#union_discontent'
  get 'discontent/posts/unions', to:  'discontent/posts#unions'
  post 'concept/posts/add_dispost', to:  'concept/posts#add_dispost'
  put 'concept/posts/next_vote', to:  'concept/posts#next_vote'
  get 'discontent/posts/fast_discussion_discontents', to:  'discontent/posts#fast_discussion_discontents'
  get 'concept/posts/fast_discussion_concepts', to:  'concept/posts#fast_discussion_concepts'
  get 'discontent/posts/check_field', to:  'discontent/posts#check_field'
  get 'concept/posts/check_field', to:  'concept/posts#check_field'
  get 'discontent/posts/new_group', to:  'discontent/posts#new_group'
  put 'discontent/posts/create_group', to:  'discontent/posts#create_group'



  namespace :discontent do
    resources :aspects
    posts_routes
    resources :posts do
      member do
        put :remove_union
        put :add_union
        put :next_post_for_vote
        put :status_post
        put :new_note
        put :create_note
        put :destroy_note
        put :ungroup_union
        get :edit_group
        put :update_group
        put :destroy_group
        put :union_group
      end
    end
  end

  namespace :concept do
    posts_routes
    resources :posts do
      member do
        put :status_post
        put :new_note
        put :create_note
        put :destroy_note
      end
    end
  end

  post 'plan/posts/get_cond', to:  'plan/posts#get_cond'
  post 'plan/posts/get_cond1', to:  'plan/posts#get_cond1'
  post 'knowbase/posts/sortable_save', to:  'knowbase/posts#sortable_save'
  put 'plan/posts/change_estimate_status', to:  'plan/posts#change_estimate_status'

  namespace :plan do
    posts_routes
    resources :posts do
      post :get_concepts, :on => :collection
      member do
        put :add_concept
        put :new_stage
        put :edit_stage
        put :create_stage
        put :update_stage
        delete :destroy_stage
        put :edit_concept
        delete :destroy_concept
        put :new_action
        put :edit_action
        put :create_action
        put :update_action
        delete :destroy_action
        put :add_form_for_concept
        put :update_concept
        get :get_concept
        put :update_get_concept
        put :render_table
        put :render_concept_side
        get :view_concept
        get :view_concept_table
        put :new_note
        put :create_note
        put :destroy_note
      end
    end
  end

  namespace :estimate do
    posts_routes
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
      #get 'censored/:post_id'  => 'posts#censored'
      posts_routes
      #resources :posts do
      #  member do
      #    put :add_comment
      #    put :censored_comment
      #
      #    put :plus
      #    put :plus_comment
      #  end
      #end
      #put 'project/:project/stage/:stage/essay/posts/:id/add_comment', to:  'plan/posts#change_estimate_status'
      #resources :posts do
      #  member do
      #    put :add_comment
      #    put :update_comment
      #    put :destroy_comment
      #    put :to_archive
      #    put :censored_comment
      #    put :plus
      #    get :edit_comment
      #    put :plus_comment
      #    put :set_required
      #    put :add_child_comment_form
      #  end
      #end
    end
  end


  
end


############



  root :to => 'core/projects#index'

end
