module ApplicationHelper

  #returns a title on a per-page basis
  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    if @title.nil?            # boolean test for nil
      base_title              # implicit return
    else
      "#{base_title} | #{@title}"   #string interpolation, implicit return
    end
  end

end
