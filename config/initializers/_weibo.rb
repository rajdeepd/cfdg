#the file name should be "_XXXXX" is Init the contant before devise
case Rails.env
when 'development'
  ENV['WEIBO_ID'] = '2047193824'
  ENV['WEIBO_SECRET'] = '9601d3f9a89da07386ae671ac19e1328'
when 'staging'
  ENV['WEIBO_ID'] = '3847688790'
  ENV['WEIBO_SECRET'] = 'cd73aebcfcd2d34096bd46300a8ad4a9'
when 'production'
  ENV['WEIBO_ID'] = '3014686913'
  ENV['WEIBO_SECRET'] = '9929ae903db46e0ac73332ca6a10d081'
end
