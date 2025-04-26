Rails.application.routes.draw do
  # Add the following to Root URL
# Routing is to call an action in contollers

  # GET / => static_pages#home

  # Root URL <https://legendary-disco-9jg59vxwgvx37449-3000.app.github.dev/>
  #root 'hello#index'
  root 'static_pages#home'

  # GET /static_pages/home => static_pages#home
  # https://legendary-disco-9jg59vxwgvx37449-3000.app.github.dev/static_pages/home
  # https://legendary-disco-9jg59vxwgvx37449-3000.app.github.dev/stati--_pages/help

  # MEMO: 現実には、コントローラー名 "static_pages" はここに書かない。以下が通常：
  # GET /help
  # GET /about
  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/about' # added about page
  get 'static_pages/contact' # added about page
end
