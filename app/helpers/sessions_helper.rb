module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    # 上のコードを実行すると、ユーザーのブラウザ内の一時cookiesに暗号化済みのユーザーIDが自動で作成される。
    # これは、Railsのセッション管理機能を利用しているため。
    # sessionメソッドで作成された一時cookiesは、ブラウザを閉じた瞬間に有効期限が終了する。
    # sessionメソッドで作成した一時cookiesは自動的に暗号化される
    session[:user_id] = user.id
    # session[:user_id]にユーザーIDを保存することで、ログイン状態を維持する
    session[:session_token] = user.session_token
  end

  #def current_user
  #  return unless session[:user_id]
  #  # session[:user_id]が存在する場合に、データベースからユーザーを取得する
  #  # ||= は、@current_userがnilまたはfalseの場合にのみ、右辺の式を評価する
  #  @current_user ||= User.find_by(id: session[:user_id])
  #end

  # 永続的セッションのためにユーザーをデータベースに記憶する
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 記憶トークンのcookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      user = User.find_by(id: user_id)
      if user && session[:session_token] == user.session_token
        @current_user = user
      end
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # 渡されたユーザーがカレントユーザーであればtrueを返す
  def current_user?(user)
    user && user == current_user
  end


  def logged_in?
    !current_user.nil?
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end

  # URLを保存する
  def store_location
    # request.get? # GETリクエストの場合のみ、現在のURLを保存する
    # request.original_url # GETリクエストの元のURLを取得する
    # これを、forwarding_urlに保存する
    session[:forwarding_url] = request.original_url if request.get?
  end
end
