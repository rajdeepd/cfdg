#CarrierWave.configure do |config|
#  config.storage = :file
#  config.enable_processing = true
#end

CarrierWave.configure do |config|
  config.fog_credentials = {
      :provider               => 'AWS',       # required
      :aws_access_key_id      => 'AKIAI4SMFTTLMHTNSY7A',       # required
      :aws_secret_access_key  => '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'       # required
      #:region                 => 'eu-west-1'  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'cfdg-test'                     # required

end