CollectiveMind::Application.routes.draw do

resources :users

namespace :core, :shallow => true do 
  resources :projects do
    member do
      get :next_stage
      get :pr_stage
    end
  end 
end

match '/project/:project', :to => 'core/projects#to_project'
match '/savelzon', :to =>'pages#savelzon'
match '/vayntrub', :to =>'pages#vayntrub'
match '/reviews', :to =>'pages#reviews'
match '/contacts', :to =>'pages#contacts'
match '/description', :to =>'pages#description'


scope '/project/:project' do
  match '/knowledge', :to =>'core/projects#knowledge'
  match '/help', :to => 'core/projects#help'
  match '/journal', :to => 'journal#index'

  match '/article1', :to => 'core/projects#article1'
  match '/article2', :to => 'core/projects#article2'
  match '/article3', :to => 'core/projects#article3'
  match '/article4', :to => 'core/projects#article4'
  match '/article5', :to => 'core/projects#article5'

  match '/help_0', :to => 'core/projects#help_0'
  match '/help_d0', :to => 'core/projects#help_d0'
  match '/help_t0', :to => 'core/projects#help_t0'
  match '/help_t1', :to => 'core/projects#help_t1'
  match '/help_t2', :to => 'core/projects#help_t2'
  match '/help_s0', :to => 'core/projects#help_s0'
  match '/help_s1', :to => 'core/projects#help_s1'
  match '/help_s2', :to => 'core/projects#help_s2'
  match '/help_s2_1', :to => 'core/projects#help_s2_1'
  match '/help_s3', :to => 'core/projects#help_s3'
  match '/help_s3_1', :to => 'core/projects#help_s3_1'

  resources :users do
    member do
      put :forecast
      put :forecast_concept
      put :forecast_plan
      match 'add_score/:score' => 'users#add_score'
      match 'add_score_essay/:score' => 'users#add_score_essay'
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

  namespace :life_tape do
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
        put :plus
        put :plus_comment
      end
    end
  end

  namespace :discontent do
    resources :aspects 

    get 'vote_list'  => 'posts#vote_list'
    put 'vote/:post_id'  => 'posts#vote'
    get 'censored/:post_id'  => 'posts#censored'
    put 'make_mandatory/:post_id'  => 'posts#make_mandatory'

    scope '/status/:status/aspect/:aspect',  :defaults => {:status => 0, :aspect => 0} do
      get 'replace/:replace_id/posts/new'  => 'posts#new'
      get 'my'   => 'posts#my'
      resources :posts do
            member do
                put :add_comment
                put :plus
                put :plus_comment
                put :censored_comment

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

  get 'journal/enter'

  resources :tests do
    member do
      put :save_attempt
    end
  end


  match '/about', :to => 'pages#about'
  match '/contacts', :to => 'pages#contacts'
 
  match '/help', :to => 'pages#help'
  match '/help0', :to => 'pages#help0'
  match '/help_0', :to => 'pages#help_0'
  match '/help1', :to => 'pages#help1'
  match '/help2', :to => 'pages#help2'
  match '/help3', :to => 'pages#help3'
  match '/help4', :to => 'pages#help4'
  match '/help5', :to => 'pages#help5'
  match '/help6', :to => 'pages#help6'
  match '/help7', :to => 'pages#help7'

  match '/estimate/result', :to => 'pages#result'
  match '/home', :to => 'pages#home'
  match '/donot', :to => 'pages#donot'  
  match '/articles', :to => 'pages#articles'

  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  match '/frustrations/structure', :to => 'pages#structure_frustrations'
  match '/frustrations/unstructure', :to => 'pages#unstructure_frustrations'
  match '/frustrations/archive', :to => 'pages#archive_frustrations'  
  match '/frustrations/to_expert', :to => 'pages#to_expert_frustrations'
  match '/frustrations/accepted', :to => 'pages#accepted_frustrations'  
  match '/frustrations/declined', :to => 'pages#declined_frustrations'    
  match '/frustrations/voted', :to => 'pages#voted_frustrations'    
  match '/frustrations/show_forecast', :to => 'frustrations#show_forecast'    


  #get 'users/new'


  
  resources :sessions, :only => [:new, :create, :destroy]

  
  #match 'frustrations/archive/:id/', :to =>'frustrations#archive'
  match '/signup', :to =>'users#new'
  get 'welcome/index'
  
  resources :posts do
    resources :comments
  end

  root :to => 'core/projects#index'

end
