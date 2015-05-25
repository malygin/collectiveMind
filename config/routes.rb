require 'resque/server'
#@todo их почему то больше нет
#require 'resque_scheduler'
#require 'resque_scheduler/server'

CollectiveMind::Application.routes.draw do

  # resque_constraint = lambda do |request|
  #   request.env['warden'].authenticate? and request.env['warden'].user.prime_admin?
  # end
  #
  # constraints resque_constraint do
  #   mount Resque::Server.new, at: "/resque"
  # end

  def posts_routes
    get 'autocomplete', to: 'posts#autocomplete'
    put 'vote/:post_id' => 'posts#vote'

    resources :posts do
      get :user_content, on: :collection
      put :check_field, on: :collection

      member do
        put :to_archive
        put :plus
        put :discuss_status
        put :like
        put :vote
        put :status_post
        put :publish
        get :edit_comment
        put :plus_comment
        put :comment_status
        put :add_comment
        put :update_comment
        put :destroy_comment
        put :like_comment
      end
    end
  end

  devise_for :users

  get '/project/:id', to: 'core/projects#show'
  get '/project/:id/next_stage', to: 'core/projects#next_stage'
  get '/project/:id/prev_stage', to: 'core/projects#prev_stage'

  # resources :groups do
  #   put :upload_file
  #   put :become_member
  #   put :leave
  #   put 'invite_user/:user_id', action: 'invite_user'
  #   put :take_invite
  #   put :reject_invite
  #   put :call_moderator
  # end
  # resources :group_tasks, only: [:new, :edit, :create, :update, :destroy] do
  #   put 'assign_user/:user_id', action: 'assign_user'
  # end


  scope '/project/:project' do

    resources :news do
        get :read, on: :member
    end

    namespace :knowbase, :module => false do
      resources :posts, controller: 'core/knowbase/posts'
    end

    resources :users, except: [:edit] do
      collection do
        get :list_users
        get :search
      end
      member do
        post :update_score
        put :journal_clear
        # mail sender
        get :edit_notice
        post :create_notice
        get 'add_score/:score' => 'users#add_score'
      end
    end

    namespace :aspect, :module => false do
      resources :posts, controller: 'core/aspect/posts' do
        member do
          put :discuss_status
          put :add_comment
          put :update_comment
          put :destroy_comment
          put :to_archive
          put :plus
          get :edit_comment
          put :plus_comment
          put :comment_status
          put :like
          put :like_comment
          put :vote
        end
      end
    end

    namespace :collect_info do
      posts_routes
      resources :posts do
          put :answer_question, on: :member
      end
    end


    namespace :discontent do
      posts_routes
    end


    namespace :concept do
      posts_routes
    end

    namespace :novation do
      posts_routes
      resources :posts do
          put :answer_content_question,  on: :member
      end
    end

    namespace :plan do
      posts_routes
    end

    namespace :estimate do
      posts_routes
    end

    namespace :completion_proc do
      resources :posts
    end

    # scope '/stage/:stage' do
    #   namespace :essay do
    #     posts_routes
    #   end
    # end

  end

  ############

  root to: 'home#index'
end
