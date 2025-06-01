require "test_helper"

class UserTest < ActiveSupport::TestCase
  # setup method is run before each test
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     # passwordとpassword_confirmationは、has_secure_passwordメソッドによって追加された仮想的な属性
                     # DBにはpasswordから入力された平文パスワードをハッシュ化した値がpassword_digestに登録される。
                     # これらのカラムはDBにはないので登録されない。
                     password: "foobarxxx", password_confirmation: "foobarxxx")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    # Update user.name to be blank
    @user.name = "     "
    # Expect the user to be invalid
    assert_not @user.valid?
  end

  test " email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    # Set the name to a string of 51 characters (51 <- ERROR CASE)
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    # Set the email to a string of 244 characters brfore the @example.com domain (256 <- ERROR CASE)
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com 
                          USER@foo.COM 
                          A_US-ER@foo.bar.org
                          first.last@foo.jp 
                          alice+bob@baz.cn]
    # Iterate through each valid address and set it to @user.email
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      # Check if the user is valid
      # If failed, it will show the invalid address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com 
                            user_at_foo.org 
                            user.name@example.
                            foo@bar_baz.com 
                            foo@bar+baz.com
                            foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      # Check if the user is invalid
      # If failed, it will show the invalid address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    # .dupメソッドは、オブジェクトのコピーを作成する
    duplicate_user = @user.dup
    # @userをデータベースに保存
    @user.save
    # duplicate_user
    assert_not duplicate_user.valid?, "#{duplicate_user.email.inspect} should be invalid"
  end

  test "password should be present (nonblank)" do
    # Set the password to a string of 8 spaces
    # passwordは、has_secure_passwordメソッドによってDBに登録されない
    @user.password = @user.password_confirmation = " " * 8
    assert_not @user.valid?, "#{@user.password.inspect} should be invalid"
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 7
    assert_not @user.valid?, "#{@user.password.inspect} should be invalid"
  end

  test "associated microposts should be destroyed" do
    @user.save # Save the user to the database
    @user.microposts.create!(content: "Lorem ipsum") # Create an associated micropost
    assert_difference 'Micropost.count', -1 do       
      @user.destroy                                  
    end
    # The assert_difference method checks 
    # that the count of Microposts decreases by 1 when the user is destroyed
    # do ... end works before assert_difference
    # @user.microposts.create!(content: "Lorem ipsum") creates a micropost associated with the user
    # assert_difference 'Micropost.count', -1 do checks that the count of Microposts decreases by 1 when the user is destroyed
  end
end
