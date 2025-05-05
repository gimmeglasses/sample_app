module ApplicationHelper
  # if page_title is given by caller, use it. If not, use blank title
  def full_title(page_title = '')
    base_title =  "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      # page_title + " | " + base_title. <- old style
      "#{page_title} | #{base_title}"
    end
  end
end
