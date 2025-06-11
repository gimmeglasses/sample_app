class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  # dependent: :destroyは、ユーザーが削除された場合に、そのユーザーに関連するマイクロポストも削除されることを意味する
  # 
  # accessorは、インスタンス変数を定義するためのメソッド
  attr_accessor :remember_token
  # "before_save" (コールバック) works before the record is saved to the database
  # provided email address is downcased, thus no need of case_sensitive
  before_save { self.email = email.downcase }
  # ApplicationRecordクラスの継承によって、アクティブレコードを利用できる様になる
  # Apply validations to the model
  # Validates that the name attribute is present
  validates :name,  presence: true, length: { maximum: 50 }
  # Validates that the email attribute is present
  # データベースでは文字列の上限を255としているので、それに合わせて255文字を上限にする
  # 正規表現を使って、メールアドレスの形式を検証する
  # 大文字小文字を区別しているので、case_sensitive:
  # Railsはこの場合、:uniquenessをtrueと判断する (emailのユニークネスを検証する)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    # uniqueness: { case_sensitive: false }
                    uniqueness: true
  has_secure_password
  # has_secure_passwordは、bcryptを使ってパスワードのハッシュ化を行う
  # また、passwordとpassword_confirmationの検証を行う
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
  # allow_nil: trueは、パスワードが空の場合は検証を行わない

  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続化セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    # remember_digestがnil（記憶ダイジェストを持たない）とは、ユーザがすでにログアウトしているということ。　
    return false if remember_digest.nil?
    # is_password?メソッドは、BCrypt::Passwordオブジェクトに対して呼び出される
    # remember_digestがnilの場合は、falseを返す
    # remember_digestがnilの場合は、ユーザーがログインしていないことを意味する
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  # セッションハイジャック防止のためにセッショントークンを返す
  # この記憶ダイジェストを再利用しているのは単に利便性のため
  def session_token
    remember_digest || remember
  end

  # 試作feedの定義
  # 完全な実装は次章の「ユーザーをフォローする」を参照
  # def feed
  #   Micropost.where("user_id = ?", id)
  #   # ?があることで、SQLクエリに代入する前にidがエスケープされるため、SQLインジェクション（SQL Injection）と呼ばれる深刻なセキュリティホールを回避できる
  # end

  # ユーザーのステータスフィードを返す
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
      # following_ids 
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
             .includes(:user, image_attachment: :blob)     # eager loading　「N+1 クエリ問題」対策ここでは、マイクロポストに対応するユーザーと、添付画像があればその画像もincludesメソッドの引数に指定
  end

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user unless self == other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    following.delete(other_user)
  end

  # 現在のユーザーが他のユーザーをフォローしていればtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

end
