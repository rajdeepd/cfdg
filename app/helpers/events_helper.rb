module EventsHelper
  def get_event_address(event)
    #return "#{event.venue} #{event.address_line1} #{event.address_line2} #{event.city_name} #{event.postal_code}"
    address = "#{event.venue}"
    address =  address +"," + event.address_line1 + "," if event.address_line1.present?
    address = address + event.address_line2 + "," if event.address_line2.present?
    address = address + event.city_name + "," if event.city_name.present?
    address = address + event.postal_code
    return address
  end
end
