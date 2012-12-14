# To change this template, choose Tools | Templates
# and open the template in the editor.

class CityNameValidator < ActiveModel::Validator
  def validate(record)
    begin
    Gmaps4rails.geocode(record.city_name) if record.city_name.present?
    rescue  Gmaps4rails::GeocodeStatus
      record.errors[:city_name] << "Invalid City name"
    end
  end
end