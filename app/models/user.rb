class User < ApplicationRecord
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
  validates :password, presence: true, length: { minimum: 8 }

  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end
end
