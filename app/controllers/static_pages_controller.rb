class StaticPagesController < ApplicationController
  # def = action that works when GET request (routes.rb) called
  def home
    # rails set default view as below
    # ==> app/views/static_pages/home.html.erb
  end

  def help
    # rails set default view as below
    # ==> app/views/static_pages/help.html.erb
    # roots / root
    # routes / route
  end
end
