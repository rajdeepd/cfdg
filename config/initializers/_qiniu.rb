#the file name should be "_XXXXX" is Init the contant before devise
case Rails.env
when 'development'
  ENV['QINIU_ACCESS_KEY'] = 'qyy1HLcxgJKeNMxZHt7hGMwBmCpoYdstsu5Bsf7W'
  ENV['QINIU_SECRET_KEY'] = 'g4QjbAOWGlOcz741DAwu1Kz82FwBzec4CdxqHuP-'
  ENV['QINIU_BUCKET'] = 'cfdguploadsdev'
  ENV['QINIU_HOST'] = 'http://cfdguploadsdev.qiniudn.com'
when 'staging'
  ENV['QINIU_ACCESS_KEY'] = 'qyy1HLcxgJKeNMxZHt7hGMwBmCpoYdstsu5Bsf7W'
  ENV['QINIU_SECRET_KEY'] = 'g4QjbAOWGlOcz741DAwu1Kz82FwBzec4CdxqHuP'
  ENV['QINIU_BUCKET'] = 'cfdguploadsdev'
  ENV['QINIU_HOST'] = 'http://cfdguploadsdev.qiniudn.com'
when 'production'
  ENV['QQ_ID'] = '100361074'
  ENV['QQ_SECRET'] = '6fadb81eeaea40fb0af24bbd6c34fb45'
end
