#the file name should be "_XXXXX" is Init the contant before devise
case Rails.env
when 'development'
  ENV['QQ_ID'] = '100361074'
  ENV['QQ_SECRET'] = '6fadb81eeaea40fb0af24bbd6c34fb45'
when 'staging'
  ENV['QQ_ID'] = '100361074'
  ENV['QQ_SECRET'] = '6fadb81eeaea40fb0af24bbd6c34fb45'
when 'production'
  ENV['QQ_ID'] = '100365389'
  ENV['QQ_SECRET'] = 'add24588ea1802bb4fdc8df31eef7820'
end
