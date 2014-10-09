CollectiveMind::Application.routes.draw do

  def posts_routes
    get 'vote_list'  => 'posts#vote_list'
    put 'vote/:post_id'  => 'posts#vote'
    get 'censored/:post_id'  => 'posts#censored'
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
        put :add_child_comment_form
        put :comment_status
      end
    end
  end

devise_for :users
get '/project/:project', to: 'core/projects#to_project'
get '/list_projects', to: 'core/projects#list_projects'

namespace :core, shallow: true do
  resources :projects do
    member do
      get :next_stage
      get :pr_stage
    end
  end 
end

scope '/project/:project' do
  get '/journals', to: 'journal#index'
  #get '/help/posts/0', to: 'help/posts#new_help_0'

  namespace :help do
    resources :posts
  end

  post 'knowbase/posts/sortable_save', to: 'knowbase/posts#sortable_save'
  namespace :knowbase do
    resources :posts
  end

  resources :users do
    get :show_top, on: :collection
    get :users_rc, on: :collection
    get :list_users, on: :collection
    get :search_users, on: :collection
    member do
      post :update_score
      put :club_toggle
      put :add_user_for_project
      put :remove_user_for_project
      get 'add_score/:score' => 'users#add_score'
      get 'add_score_essay/:score' => 'users#add_score_essay'
    end
  end

  put 'life_tape/posts/transfer_comment' , to: 'life_tape/posts#transfer_comment'
  get 'life_tape/posts/check_field', to: 'life_tape/posts#check_field'
  get 'discontent/posts/check_field', to: 'discontent/posts#check_field'
  get 'concept/posts/check_field', to: 'concept/posts#check_field'
  get 'plan/posts/check_field', to: 'plan/posts#check_field'
  get 'estimate/posts/check_field', to: 'estimate/posts#check_field'

  get 'life_tape/posts/to_work', to: 'life_tape/posts#to_work'
  get 'discontent/posts/to_work', to: 'discontent/posts#to_work'
  get 'concept/posts/to_work', to: 'concept/posts#to_work'
  get 'plan/posts/to_work', to: 'plan/posts#to_work'
  get 'estimate/posts/to_work', to: 'estimate/posts#to_work'

  namespace :life_tape do
    posts_routes
    resources :posts do
      get :vote_top, on: :collection
      member do
        put :set_aspect_status
      end
    end
  end

  get :autocomplete_discontent_post_whend_discontent_posts , to: 'discontent/posts#autocomplete_discontent_post_whend'
  get :autocomplete_discontent_post_whered_discontent_posts , to: 'discontent/posts#autocomplete_discontent_post_whered'
  get :autocomplete_concept_post_resource_concept_posts , to: 'concept/posts#autocomplete_concept_post_resource'
  get :autocomplete_concept_post_mean_concept_posts , to: 'concept/posts#autocomplete_concept_post_mean'

  post 'discontent/posts/:id/union', to: 'discontent/posts#union_discontent'
  get 'discontent/posts/unions', to: 'discontent/posts#unions'
  get 'discontent/posts/new_group', to: 'discontent/posts#new_group'
  put 'discontent/posts/create_group', to: 'discontent/posts#create_group'

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
        put :discuss_status
        put :set_required
        put :set_grouped
      end
    end
    resources :post_advices
  end

  post 'concept/posts/add_dispost', to: 'concept/posts#add_dispost'
  put 'concept/posts/next_vote', to: 'concept/posts#next_vote'
  namespace :concept do
    posts_routes
    resources :posts do
      member do
        put :status_post
        put :new_note
        put :create_note
        put :destroy_note
        put :discuss_status
      end
    end
  end

  put 'plan/posts/change_estimate_status', to: 'plan/posts#change_estimate_status'

  namespace :plan do
    posts_routes
    resources :posts do
      post :get_concepts, on: :collection
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

  scope '/stage/:stage' do
    namespace :essay do
      posts_routes
    end
  end
end

############

root to: 'core/projects#index'

end
