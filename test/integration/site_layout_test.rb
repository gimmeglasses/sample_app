require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
    get root_path # => GET access to /static_pages/home 
    assert_template 'static_pages/home' # static_pages/home is displayed
    assert_select "a[href=?]", root_path, count: 2 # there are two links to root_path
    assert_select "a[href=?]", help_path # there is one link to help_path
    assert_select "a[href=?]", about_path # there is one link to about_path
    assert_select "a[href=?]", contact_path # there is one link to contact_path
    assert_select "a[href=?]", signup_path # there is one link to signup_path
  end
end
