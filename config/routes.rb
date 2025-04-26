Rails.application.routes.draw do
  # Add the following to Root URL
  # Root URL <https://legendary-disco-9jg59vxwgvx37449-3000.app.github.dev/>
  # https://legendary-disco-9jg59vxwgvx37449-3000.app.github.dev/static_pages/home
  # https://legendary-disco-9jg59vxwgvx37449-3000.app.github.dev/static_pages/help
  get 'static_pages/home'
  get 'static_pages/help'
  root "hello#index"
end
