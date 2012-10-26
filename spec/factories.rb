#By using the symbl :user, we get Factory Girl tos simulate the user model

Factory.define  :user do | user |
  
  user.name       "Michael Hartl"
  user.email      "mhartl@example.com"
  user.password   "foobar"
  user.password_confirmation "foobar"
  
  
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :micropost do |m|
  m.content "Foobar"
  m.association :user
end



