
class User
  attr_accessor :name, :email
  
  # special method, will get called automatically by Ruby on .new
  
  def initialize(attributes = {})
    @name = attributes[:name]
    @email = attributes[:email]
    
  end
  
  def formatted_email
    "#{@name} <#{@email}>"
  end
end

