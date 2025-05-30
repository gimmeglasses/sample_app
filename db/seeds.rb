# メインのサンプルユーザーを1人作成する
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "12345678",
             password_confirmation: "12345678",
             admin: true)

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password12"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end
