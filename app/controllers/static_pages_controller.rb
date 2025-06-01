class StaticPagesController < ApplicationController
  # 呼び名：
  # - キャメルケース（大文字を含む）　StaticPagesController
  # - スネークケース（小文字を使う）　static_pages_controller.rb
  # def = action that works when GET request (routes.rb) called
  def setup
    @base_title = 'Ruby on Rails Tutorial Sample App'
  end

  def home
    # if there is no code here,
    # rails set default view as below
    # ==> app/views/static_pages/home.html.erb
    # @micropost = current_user.microposts.build if logged_in?

    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
    # rails set default view as below
    # ==> app/views/static_pages/help.html.erb
  end

  def about
    # rails set default view as below
    # ==> app/views/static_pages/about.html.erb
  end

  def contact
    # rails set default view as below
    # ==> app/views/static_pages/contact.html.erb
  end
end
