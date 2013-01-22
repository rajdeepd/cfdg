namespace :helper do
  task :sync_locales => :environment do
    require 'ya2yaml'
    
  
    def sync_hashes(src, dest)
      src.each do |key, value|
        if value.is_a?(Hash)
          dest[key] = Hash.new if dest[key].nil? || dest[key].blank?
          sync_hashes(src[key], dest[key])
        elsif value.is_a?(String)
          dest[key] = value if dest[key].nil? || dest[key].blank?
        end
      end
    end


    rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'

    cn_file = "#{rails_root}/config/locales/cn.yml"
    en_file = "#{rails_root}/config/locales/en.yml"

    cn = YAML.load_file(cn_file)
    en = YAML.load_file(en_file)

    sync_hashes(en["en"], cn["cn"])

    File.open(cn_file, "w") do |f|
      f.write(cn.ya2yaml(:syck_compatible => true, :preserve_order => true))
    end
  end
end
