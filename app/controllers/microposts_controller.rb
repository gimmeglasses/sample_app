class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  # createアクションは、マイクロポストを作成するためのアクション
  def create
    # current_user.microposts.buildは、現在のユーザに紐づくマイクロポストを作成するためのメソッド
    @micropost = current_user.microposts.build(micropost_params) 
    # マイクロポストの画像を添付する
    @micropost.image.attach(params[:micropost][:image])
    # マイクロポストの保存する
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      # マイクロポストの作成に失敗した場合、エラーメッセージを表示する
      # _feed.html.erb <%= render @feed_items %>
      # @feed_items は、microposts インスタンスの配列
      # 従って、@feed_items を現在のユーザ情報で再度設定する必要がある
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home', status: :unprocessable_entity
    end
  end

  # destroyアクションは、マイクロポストを削除するためのアクション
  def destroy
    # current_user.microposts.find_by(id: params[:id])は、現在のユーザに紐づくマイクロポストを取得する
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    if request.referrer.nil?
      redirect_to root_url, status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  private
    # strong_parametersを使用して、マイクロポストのパラメータを取得する
    def micropost_params
      # params.require(:micropost)は、マイクロポストのパラメータを取得する
      params.require(:micropost).permit(:content, :image)
    end

    def correct_user
      # current_user.microposts.find_by(id: params[:id])は、現在のユーザに紐づくマイクロポストを取得する
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url, status: :see_other if @micropost.nil?
    end
end
