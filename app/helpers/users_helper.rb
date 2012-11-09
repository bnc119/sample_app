module UsersHelper
  
  # all helper classes are available in all views
  def gravatar_for(user, options = { :size => 50 } )
    gravatar_image_tag(user.email.downcase, :alt => user.name,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end
  
  def gravatar_for_email(email, name, options = { :size => 50 } )
    gravatar_image_tag(email.downcase, :alt => name,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end
    
end
