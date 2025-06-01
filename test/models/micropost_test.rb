require "test_helper"

class MicropostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    # このコードは慣習的に正しくない
    # @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
    # 代わりに、ユーザーの関連付けを利用して新しいMicropostを作成する
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end
  test "user id should be present" do # relevant to model validation
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  test "content should be present" do # relevant to model validation
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do # relevant to model validation
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
