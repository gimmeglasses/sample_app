module UsersHelper

  # 引数で与えられたユーザーのGravatar画像を返す
  def gravatar_for(user)
    # GravatarのURLを生成するために、ユーザーのメールアドレスをMD5ハッシュ化
    gravatar_id  = Digest::MD5::hexdigest(user.email.downcase)
    # GravatarのURLを生成
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"

    # 暗黙の戻り値(４章でも扱ったもの)
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
