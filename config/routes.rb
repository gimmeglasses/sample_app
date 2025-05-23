Rails.application.routes.draw do
  # get 'users/new'
  # Add the following to Root URL
  # Routing is to call an action in contollers

  # GET / => static_pages#home

  # Root URL <https://legendary-disco-9jg59vxwgvx37449-3000.app.github.dev/>
  # root 'hello#index'
  # rootメソッドを使ってルートURL "/" をコントローラーのアクションに紐付け
  # root_pathやroot_urlといったメソッドを通してURLを参照することができる
  # ルートURLにアクセスすると、static_pagesコントローラーのhomeアクションが呼ばれる
  root 'static_pages#home'

  # GET /static_pages/home => static_pages#home
  # https://legendary-disco-9jg59vxwgvx37449-3000.app.github.dev/static_pages/home
  # https://legendary-disco-9jg59vxwgvx37449-3000.app.github.dev/static_pages/help

  # MEMO: 現実には、コントローラー名 "static_pages" はここに書かない。以下が通常：
  # GET /help
  # GET /about
  # get 'static_pages/home'
  # get 'static_pages/help'
  # get 'static_pages/about' # added about page
  # get 'static_pages/contact' # added about page
  get  '/help',    to: 'static_pages#help' # GETリクエストが/helpに送信されたときにStaticPagesコントローラーのhelpアクションを呼び出してくれるようになる。
  # help_pathやhelp_urlといった名前付きルーティングも使えるようになる。
  get  '/about',   to: 'static_pages#about'   # /about にアクセスすると　static_pages#about　(app/controllers/static_pages_controller.rb)　アクションが呼ばれる
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'            # GETリクエストが/signupに送信されたときにUsersコントローラーのnewアクションを呼び出してくれるようになる。

  resources :users
  # => get  'users',      to: 'users#index'
  # => get  'users/:id',  to: 'users#show'
  # => get  'users/new',  to: 'users#new'
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
end
