require 'resque/server'
require 'resque_scheduler'
require 'resque_scheduler/server'

CollectiveMind::Application.routes.draw do
  resources :user_roles

  resque_constraint = lambda do |request|
    request.env['warden'].authenticate? and request.env['warden'].user.prime_admin?
  end
  constraints resque_constraint do
    mount Resque::Server.new, at: "/resque"
  end

  def posts_routes
    get 'vote_list' => 'posts#vote_list'
    put 'vote/:post_id' => 'posts#vote'
    get 'censored/:post_id' => 'posts#censored'
    get 'aspect/:aspect/posts/' => 'posts#index'

    resources :posts do
      get :vote_result, on: :collection
      get :sort_content, on: :collection
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
  get '/project/:id', to: 'core/projects#show'
  get '/general_news', to: 'core/projects#news'
  get '/general_rating', to: 'core/projects#users'

  get '/general_analytics', to: 'core/projects#general_analytics'
  get '/lifetape_analytics', to: 'core/projects#lifetape_analytics'
  get '/discontent_analytics', to: 'core/projects#discontent_analytics'
  get '/concept_analytics', to: 'core/projects#concept_analytics'
  get '/plan_analytics', to: 'core/projects#plan_analytics'
  get '/estimate_analytics', to: 'core/projects#estimate_analytics'

  resources :roles

  #get '/help/posts/0', to: 'help/posts#new_help_0'
  resources :groups do
    put :upload_file
    put :become_member
    put :leave
    put 'invite_user/:user_id', action: 'invite_user'
    put :take_invite
    put :reject_invite
    put :call_moderator
  end
  resources :group_tasks, only: [:new, :edit, :create, :update, :destroy] do
    put 'assign_user/:user_id', action: 'assign_user'
  end
  namespace :core, shallow: true do
    resources :projects do
      member do
        put :next_stage
        put :pr_stage
      end
    end
    resources :project_settings, only: :update
  end

  scope '/project/:project' do
    get '/journals', to: 'journal#index'
    get '/general_news', to: 'core/projects#news'
    get '/general_rating', to: 'core/projects#users'

    get '/general_analytics', to: 'core/projects#general_analytics'
    get '/lifetape_analytics', to: 'core/projects#lifetape_analytics'
    get '/discontent_analytics', to: 'core/projects#discontent_analytics'
    get '/concept_analytics', to: 'core/projects#concept_analytics'
    get '/plan_analytics', to: 'core/projects#plan_analytics'
    get '/estimate_analytics', to: 'core/projects#estimate_analytics'
    get :graf_data, to: 'core/projects#graf_data'


    #get '/help/posts/0', to: 'help/posts#new_help_0'
    resources :groups do
      put :become_member
      put :leave
      put 'invite_user/:user_id', action: 'invite_user'
      put :take_invite
      put :reject_invite
      put :call_moderator
    end
    resources :group_tasks, only: [:new, :edit, :create, :update, :destroy] do
      put 'assign_user/:user_id', action: 'assign_user'
    end

    namespace :help do
      resources :posts do
        get :about, on: :collection
      end
    end

    # post 'knowbase/posts/sortable_save', to: 'knowbase/posts#sortable_save'
    namespace :knowbase do
      resources :posts, :controller => 'core/knowbase/posts'
    end

    resources :users do
      collection do
        get :show_top
        get :users_rc
        get :list_users
        get :search
      end
      member do
        post :update_score
        put :club_toggle
        put :add_user_for_project
        put :remove_user_for_project
        put :journal_clear
        get :edit_notice
        post :create_notice
        get 'add_score/:score' => 'users#add_score'
        get 'add_score_essay/:score' => 'users#add_score_essay'
      end
    end

    put 'collect_info/posts/transfer_comment', to: 'collect_info/posts#transfer_comment'
    put 'collect_info/posts/check_field', to: 'collect_info/posts#check_field'
    put 'discontent/posts/check_field', to: 'discontent/posts#check_field'
    put 'concept/posts/check_field', to: 'concept/posts#check_field'
    put 'plan/posts/check_field', to: 'plan/posts#check_field'
    put 'estimate/posts/check_field', to: 'estimate/posts#check_field'

    get 'collect_info/posts/to_work', to: 'collect_info/posts#to_work'
    get 'discontent/posts/to_work', to: 'discontent/posts#to_work'
    get 'concept/posts/to_work', to: 'concept/posts#to_work'
    get 'plan/posts/to_work', to: 'plan/posts#to_work'
    get 'estimate/posts/to_work', to: 'estimate/posts#to_work'

    namespace :collect_info do
      posts_routes
      resources :posts do
        get :vote_top, on: :collection
        member do
          put :set_aspect_status
        end
      end
    end

    get :autocomplete_discontent_post_whend_discontent_posts, to: 'discontent/posts#autocomplete_discontent_post_whend'
    get :autocomplete_discontent_post_whered_discontent_posts, to: 'discontent/posts#autocomplete_discontent_post_whered'
    get :autocomplete_concept_post_resource_concept_posts, to: 'concept/posts#autocomplete_concept_post_resource'
    get :autocomplete_concept_post_mean_concept_posts, to: 'concept/posts#autocomplete_concept_post_mean'

    post 'discontent/posts/:id/union', to: 'discontent/posts#union_discontent'
    get 'discontent/posts/unions', to: 'discontent/posts#unions'
    get 'discontent/posts/new_group', to: 'discontent/posts#new_group'
    put 'discontent/posts/create_group', to: 'discontent/posts#create_group'

    namespace :discontent do
      resources :aspects do
        member do
          put :answer_question
        end
      end
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
          get :show_comments
        end
      end
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

    resources :advices, only: [:index, :edit, :update, :destroy] do
      member do
        put :approve
        put :not_approve
        put :useful
        put :not_useful
      end
      resources :comments, only: [:new, :create, :destroy], controller: 'advice_comments'
    end
  end

  ############

  root to: 'home#index'
end
