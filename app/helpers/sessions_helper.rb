module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    # 上のコードを実行すると、ユーザーのブラウザ内の一時cookiesに暗号化済みのユーザーIDが自動で作成される。
    # これは、Railsのセッション管理機能を利用しているため。
    # sessionメソッドで作成された一時cookiesは、ブラウザを閉じた瞬間に有効期限が終了する。
    # sessionメソッドで作成した一時cookiesは自動的に暗号化される
    session[:user_id] = user.id
  end

  def current_user
    return unless session[:user_id]

    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  # 現在のユーザーをログアウトする
  def log_out
    reset_session
    @current_user = nil # 安全のため
  end
end
