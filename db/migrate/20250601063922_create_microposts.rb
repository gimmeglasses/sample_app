class CreateMicroposts < ActiveRecord::Migration[7.0]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    # user_idに関連付けられたすべてのマイクロポストを作成時刻の逆順で取り出しやすくする
    add_index :microposts, [:user_id, :created_at]
  end
end
