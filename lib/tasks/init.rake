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
      @cities = City.create(:name => row[1], :state_id => @state.id, :detail => row[4].gsub(/\|/, ''))
      puts @cities.inspect
    end
  end

  task :all => [:countries, :states, :cities]
end
