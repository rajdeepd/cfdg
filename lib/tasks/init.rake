# encoding: utf-8

namespace :init do
  task :countries => :environment do
    @country = Country.create(:name => "中华人民共和国")
    puts @country.inspect
  end

  task :states => :environment do
    @country = Country.all.first
    require 'csv'
    CSV.foreach(Rails.root.join("cn_states.csv"),{:col_sep =>","} ) do |row|
      @state = State.create(:name => row[1], :country_id => @country.id)
      puts @state.inspect
    end
  end

  task :cities => :environment do
    require 'csv'
    CSV.foreach(Rails.root.join("cn_cities.csv"), {:col_sep =>","} ) do |row|
      @state = State.find_by_name(row[4].split('|').first)
      @city = City.create(:name => row[1], :state_id => @state.id, :detail => row[4].gsub(/\|/, ''))
      puts @city.inspect
    end
  end

  task :colleges => :environment do
    require 'csv'
    CSV.foreach(Rails.root.join("cn_universities.csv"), {:col_sep =>","} ) do |row|
      @state = State.where("name like ?", "%#{row[0]}%").first
      @college = College.create(:name => row[1], :state_id => @state.id, :renren_code => row[2])
      puts @college.inspect
    end
  end


  task :institutions => :environment do
    require 'faraday'
    require 'nokogiri'
    require 'csv'

    conn = Faraday.new(:url => 'http://www.renren.com') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    College.all.each do |college|
      if college.renren_code.to_i > 0
        response = conn.get "/GetDep.do?id=#{college.renren_code}"
        doc = Nokogiri::Slop(response.body).remove_namespaces!

        doc.css('option').each do |institution|
          college.institutions.create!(:name => institution['value']) unless institution['value'].blank?
        end
      end
    end

    college = College.find_by_name("国防科学技术大学")

    CSV.foreach(Rails.root.join("nudt_institutions.csv"), {:col_sep =>","} ) do |row|
      college.institutions.create!(:name => row[0])
    end
  end

  task :regions => [:countries, :states, :cities]
  task :educations => [:colleges, :institutions]

  task :all => [:regions, :educations]
end
