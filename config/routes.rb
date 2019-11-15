Rails.application.routes.draw do
  root 'statics#top'
  get :dashboard, to: 'teams#dashboard'

  devise_for :users, controllers: {
    #ログイン/登録/パスワード
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  resource :user
  #チームごとに、割り当てる（create,destroy）
  #チームごとに、割り当てる　agenda
  #agendaの中にarticle
  #articleの中にcomment
  resources :teams do
    resources :assigns, only: %w(create destroy)
    resources :agendas, shallow: true do
      resources :articles do
        resources :comments
      end
    end
    post 'change_team_owner'
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end