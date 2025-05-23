class SessionsController < ApplicationController
  def new; end

  # POST /login
  def create
    # userを使って、ユーザ情報を取得する。
    # userはemailで検索が可能。
    user = User.find_by(email: params[:session][:email].downcase)
    # find_byは、データベースにデータがない場合、nilを返す。
    #
    # if 左側がTrueの場合、右側の処理を実行する。
    # userがnilでない場合、user.authenticateを実行する。
    # user.authenticateは、session[password]に基づいてユーザ認証を行う。
    # if !user.nil? && user.authenticate(parames[:session][:password])
    # 以下と上記は同じ意味
    if user && user.authenticate(params[:session][:password])
      # success
      # reset_session should be called before log_in
      reset_session
      log_in user
      # redirect_to user_url(user) と同じ意味
      redirect_to user
    else
      # failure
      # flash message
      # alert-danger => 赤色のフラッシュ (bootstrap)
      # flash[:danger] = "Invalid email/password combination"
      # flash.nowのメッセージはその後リクエストが発生したときに消滅
      flash.now[:danger] = 'Invalid email/password combination'
      # メッセージの内容は、Securityリスクを考慮して設定する。（あまり具体的にしない。）
      render 'new', status: :unprocessable_entity
      # renderメソッドで強制的に再レンダリングしてもリクエストと見なされないため、リクエストのメッセージが消えない。
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end
end
