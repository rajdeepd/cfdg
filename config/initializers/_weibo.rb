#the file name should be "_XXXXX" is Init the contant before devise
case Rails.env
when 'development'
  ENV['WEIBO_ID'] = '542047457'
  ENV['WEIBO_SECRET'] = '0d78128235733a26ff012f150dda25b8'
when 'staging'
  ENV['WEIBO_ID'] = '2317805385'
  ENV['WEIBO_SECRET'] = '197738a4abd28e89dcb40a0a802e9eb7'
when 'production'
  #ENV['WEIBO_ID'] = '1149708764'
  #ENV['WEIBO_SECRET'] = 'dd9334e564cf75cc1393881f9c519ccf'
  ENV['WEIBO_ID'] = '1881139527'
  ENV['WEIBO_SECRET'] = 'e8025df11a3c78164dbbb06f8e5ee1b8'
end
