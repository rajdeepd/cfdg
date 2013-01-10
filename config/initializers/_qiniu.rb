#the file name should be "_XXXXX" is Init the contant before devise
case Rails.env
when 'development'
  ENV['QINIU_ACCESS_KEY'] = '_OrITNvuapwhPQ29D4AtyiTmAJT9BScZhQZUnk4o'
  ENV['QINIU_SECRET_KEY'] = 'yL5Vy-kaoFUftMZGiTIul6LGwBsqlJDdl2byz75O'
  ENV['QINIU_BUCKET'] = 'cfdg'
when 'staging'
  ENV['QINIU_ACCESS_KEY'] = '_OrITNvuapwhPQ29D4AtyiTmAJT9BScZhQZUnk4o'
  ENV['QINIU_SECRET_KEY'] = 'yL5Vy-kaoFUftMZGiTIul6LGwBsqlJDdl2byz75O'
when 'production'
  ENV['QQ_ID'] = '100361074'
  ENV['QQ_SECRET'] = '6fadb81eeaea40fb0af24bbd6c34fb45'
end
