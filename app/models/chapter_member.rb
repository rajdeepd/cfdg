class ChapterMember < ActiveRecord::Base
  acts_as_soft_deletable         
  stampable
  belongs_to :user
  belongs_to :chapter
  # Setup accessible (or protected) attributes for your model
  attr_accessible :chapter_id, :user_id, :memeber_type
  PRIMARY_COORDINATOR = "primary coordinator"
  SECONDARY_COORDINATOR = "secondary coordinator"
  MEMBER = 'member'
 
  scope :get_chapters, lambda{|user_id| where(:user_id => user_id)}
  scope :get_member, lambda{|user_id, chapter_id| where(" user_id = ? and chapter_id = ? ", user_id, chapter_id)}
  scope :get_details_if_coordinator, lambda{|user_id| where(" user_id = ? and memeber_type in (?)", user_id, [PRIMARY_COORDINATOR, SECONDARY_COORDINATOR])}
  #scope :am_i_coordiantor?, lambda{|user_id, chapter_id)| where(" user_id = ? and chapter_id = ? and memeber_type in (?)", user_id, chapter_id, [PRIMARY_COORDINATOR, SECONDARY_COORDINATOR]]).present?}
  #scope :is_primary_coordinator?, lambda{|user_id| where(" user_id = ? and memeber_type = ?", user_id, PRIMARY_COORDINATOR).present?}
  #scope :is_secondary_coordinator?, lambda{|user_id| where(" user_id = ? and memeber_type = ?", user_id, SECONDARY_COORDINATOR).present?}
  #scope :is_just_member?, lambda{|user_id| where(" user_id = ? and memeber_type = ?", user_id, MEMBER).present?}


  def self.am_i_coordiantor?(user_id, chapter_id)
    ChapterMember.find(:all , :conditions => [" user_id = ? and chapter_id = ? and memeber_type in (?)", user_id, chapter_id, [PRIMARY_COORDINATOR, SECONDARY_COORDINATOR]]).present?
  end

  def self.is_primary_coordinator?(user_id)
  	ChapterMember.find(:all , :conditions => [" user_id = ? and memeber_type = ?", user_id, PRIMARY_COORDINATOR]).present?
  end

  def self.is_secondary_coordinator?(user_id)
  	ChapterMember.find(:all , :conditions => [" user_id = ? and memeber_type = ?", user_id, SECONDARY_COORDINATOR]).present?
  end
  
  def self.is_just_member?(user_id)
  	ChapterMember.find(:all , :conditions => [" user_id = ? and memeber_type = ?", user_id, MEMBER]).present?
  end

end
