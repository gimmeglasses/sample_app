class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [500, 500]
  end
  default_scope -> { order(created_at: :desc) } # -> はラムダ式を表す
  # default_scopeは、Micropostモデルのすべてのクエリに適用される
  # order(created_at: :desc) を指定することで、マイクロポストが作成された順に降順で取得されるようになる
  # order(created_at: :desc) を、default_scopeで指定することで、マイクロポストのクエリに常に適用される

  # バリデーション
  # user_idが存在することを確認
  # contentが存在し、最大140文字であることを確認
  # length: { maximum: 140 }は、contentの長さが140文字以下であることを保証する
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes,
                                      message:   "should be less than 5MB" }
end
