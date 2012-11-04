require 'digest'

class User < ActiveRecord::Base
  
  has_many :microposts, :dependent=> :destroy
  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  
  has_many :reverse_relationships, :foreign_key => "followed_id", 
                                   :class_name => "Relationship",
                                   :dependent => :destroy
  
  has_many :followers, :through => :reverse_relationships, :source => :follower
  
  
  # generate implicit getter and setter methods for :password
  # generate a virtual password attribute 
  attr_accessor :password
  
  # these are the variables that we allow to be editable through mass-assignment
  attr_accessible :name, :email, :password, :password_confirmation
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name, :presence => true, :length =>  { :maximum => 50}
  validates :email, :presence => true, 
                    :format => { :with =>  email_regex },
                    :uniqueness => { :case_sensitive =>false }
  
  # automatically create the virtual attribute 'password_confirmation'
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => {:within => 6..40}
  
  # define a callback to encrypt_password before the record gets saved in the database
  before_save :encrypt_password
  
  def has_password?(submitted_password)
    # compare encrypted password with the encrypted version of submitted_password
    encrypted_password == encrypt(submitted_password)
    
  end
  
  def User.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
       
  end
  
  def User.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end 
  
  def feed
    # this is preliminary
    microposts
  end
  
  def following? user
    relationships.find_by_followed_id(user)
  end
  
  def follow!(user)
    relationships.create!(:followed_id => user.id) 
  end
  
  def unfollow!(user)
    relationships.find_by_followed_id(user).destroy
  end
  
  
  
  private
  
  # callback before_save
  def encrypt_password
    self.salt = make_salt if new_record?
    # save the encrypted password
    self.encrypted_password = encrypt(password) 
  end
  
  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end
  
  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end
  
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
    
  end
  
end
