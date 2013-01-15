#the file name should be "_XXXXX" is Init the contant before devise
case Rails.env
when 'development'
  ENV['WEIBO_ID'] = '2047193824'
  ENV['WEIBO_SECRET'] = '9601d3f9a89da07386ae671ac19e1328'
when 'staging'
  ENV['WEIBO_ID'] = '3847688790'
  ENV['WEIBO_SECRET'] = 'cd73aebcfcd2d34096bd46300a8ad4a9'
when 'production'
  ENV['WEIBO_ID'] = '1881139527'
  ENV['WEIBO_SECRET'] = 'e8025df11a3c78164dbbb06f8e5ee1b8'
end
