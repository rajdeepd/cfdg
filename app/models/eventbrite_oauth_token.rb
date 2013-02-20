# TODO :: Do we need it??????

class EventbriteOauthToken < ActiveRecord::Base
stampable
belongs_to :user
acts_as_soft_deletable 
attr_accessible :user_id, :email_id, :event_brite_token
end