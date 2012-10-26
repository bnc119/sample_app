class Micropost < ActiveRecord::Base
  # this is the only field that should be editable through mass-assignment
  attr_accessible :content
  
  belongs_to :user
  
  validates :content, :presence => true, :length => {:maximum => 140}
  validates :user_id, :presence => true
  
  # use of scope facility to order "newest first'
  default_scope :order => 'microposts.created_at DESC'
end
