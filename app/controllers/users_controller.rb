class UsersController < ApplicationController
  # GET /users/:id が実行されたときに、showアクションが実行される
  def show
    # user = local variable　← viewから参照できない
    # user = User.find(params[:id])
    # @user = instance variable <- viewから参照できる
    # :id(シンボル表記)はURLの一部で、Railsが自動的にparamsハッシュに格納してくれる
    @user = User.find(params[:id])
    # @user = User.first
    # @@user = class (global) variable <- viewから参照できるが、クラス全体で共有される　Railsでは使用しない
    # @@user = User.find(params[:id])
    'hogehoge'

    # debugger
    # debuggerは、Railsのデバッグツールで、実行を一時停止して、変数の値を確認できる
    # Rails consoleで、binding.pryと同じようなことができる
  end

  # GET /users/new or sign-up
  def new
    # => GET app/views/users/new.html.erb
    @user = User.new
  end

  # POST /users　が実行されたときに、createアクションが実行される
  def create
    # params -> user -> user.save -> if ... else ... end
    ### マスアサインメント脆弱性 のある記述
    # @user = User.new(params[:user])
    #
    # params[:user] を使わない場合、以下のように書くこともできる
    # params[user[:name]]
    # params[user[:email]]
    # params[user[:password]]
    # params[user[:password_confirmation]]
    # -------------------------------------------
    # params[:user]と書くことのリスクがある。
    # 悪意のあるユーザが以下のようなリクエストを送信することができる。（実際にデータベースにadmin権限のカラムが存在する場合は、ユーザによって勝手に登録されてしまう。）
    # params[user[:admin]] = true
    # params[:user] -> name, email, password, password_confirmation に制限する必要がある。
    # => マスアサインメント脆弱性 : Rails to raise ForbiddenAttributesError
    # => Strong Parametersが解決方法の一つ : Rails 4.0以降
    # -------------------------------------------
    # Strong Parametersを使うことで、マスアサインメント脆弱性を防ぐことができる
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'Welcome to the Sample App!'
      # ユーザー登録に成功した場合
      # ユーザー登録に成功した場合は別のページにリダイレクト（Redirect）する方がWebでは一般的
      # redirect_to を利用して、ユーザー詳細画面にリダイレクトする
      # リダイレクト（指定したページに移動する指示）
      #
      # render 'show' / redirect_to @user の違い
      # もともと、POST /users を実行してこの処理に入っている。その後、
      #  - redirect_toを実行すると、GETリクエストが新たに送信される。
      #    この時、GET /users/:id が実行され、showアクションが実行される。
      #  - renderは、HTTPリクエストを送らずにshow_templateを表示する。
      # render 'show' # GET /users/:id を実行しない
      redirect_to @user # GET /users/:id を実行する
    # redirect_to user_path(@user)     # GET /users/:id を実行する。その後、
    # redirect_to user_path(@user.id)  # GET /users/2   を実行する
    else
      # ユーザー登録に失敗した場合
      #
      # render 'new'は、ユーザーが新規登録に失敗した場合に、再度新規登録画面を表示する
      # unprocessable_entityは、HTTPステータスコード422を返す
      # 422 Unprocessable Entityは、リクエストは正しいが、処理できない場合に返す
      render 'new', status: :unprocessable_entity
    end

    # もし、redirect_to をしなければ、ユーザー登録に成功した場合にユーザー詳細画面にリダイレクトする
    # render 'create'
    # しかし、create_templateは無いので、エラーになる。
  end

  # privateメソッドは、クラスの外からは呼び出せない
  # （ただし、継承している場合は使える。）
  private

  # Strong Parameters
  # user_paramsのインデントを1段深くしている。
  # クラス内に多数のメソッドがある場合にprivateメソッドの場所を見つけやすい。
  # formatter (Rubocop, etc.) を使うなど、チーム内で連携が必要。
  def user_params
    params.require(:user).permit(:name,
                                 :email,
                                 :password,
                                 :password_confirmation)
  end
end
