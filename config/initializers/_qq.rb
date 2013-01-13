#the file name should be "_XXXXX" is Init the contant before devise
case Rails.env
when 'development'
  ENV['QQ_ID'] = '100361074'
  ENV['QQ_SECRET'] = '6fadb81eeaea40fb0af24bbd6c34fb45'
when 'staging'
  ENV['QQ_ID'] = '100361074'
  ENV['QQ_SECRET'] = '6fadb81eeaea40fb0af24bbd6c34fb45'
when 'production'
  ENV['QQ_ID'] = '100361074'
  ENV['QQ_SECRET'] = '6fadb81eeaea40fb0af24bbd6c34fb45'
end

#use OmniAuth::Builder do
  #provider :qq_connect,
    #ENV['QQ_CONNECT_API_KEY'], ENV['QQ_CONNECT_API_SECRET'], scope: "get_user_info,add_share"
#end
