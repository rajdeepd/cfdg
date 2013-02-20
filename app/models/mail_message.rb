# => TODO :: Do we need it???????

class MailMessage < ActiveRecord::Base
  acts_as_soft_deletable
  belongs_to :sender, :class_name => 'User' , :foreign_key => :sender_id
  belongs_to :receiver, :class_name => 'User', :foreign_key => :received_id
  validates :body, :received_id , :sender_id,:subject, presence: true
  validates_with EmailValidator
  acts_as_nested_set
  
  attr_accessible :sender_id, :subject, :body,:received_id,:parent_id , :lft ,:rgt, :depth,:to
  attr_accessor :to

  
end
