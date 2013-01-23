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

  def attending_event_button
    content_tag(:button, "Attending", :id => "event_rsvped", :style => "opacity:0.35", 
                :class => "btn-a-small flt-right")
  end

  def rsvp_event_button(event)
    content_tag(:button, "R.S.V.P", :id => "follow_an_event", :event_id => event.id, 
                :class => "btn-a-small flt-right")
  end

  def cancelled_event_button(event)
    content_tag(:button, "CANCELLED", :id => "cancelled_event", :event_id => event.id, 
                :style => "opacity:0.35", :disable => true, :class => "btn-a-small flt-right")
  end

  def delete_event_button(event)
    content_tag(:button, "DELETE", :id => "delete_an_event", :event_id => event.id, 
                :class => "btn-a-small flt-right")
  end

  def cancel_event_button(event)
    content_tag(:button, "CANCEL", :id => "cancel_an_event", :event_id => event.id, 
                :class => "btn-a-small flt-right")
  end

  def resend_confirm_event_button(event)
    content_tag(:button, "Resend Confirmation", :id => "resend_event_confirmation", :event_id => event.id, 
                :'data-href' => resend_event_confirmation_path(), :class => "btn-a-small flt-right")
  end

  def blocked_event_button(event)
    content_tag(:button, "BLOCKED", :disabled => "disabled", :class => "btn-a-small flt-right", :style => "opacity:0.35")    
  end

  def event_action_buttons(event)
    buttons = ""
    if event.is_cancelled?
      buttons += cancelled_event_button(event)
    else
      if current_user.blank?
        buttons += rsvp_event_button(event)  
      else
        if event.am_i_member?(current_user.id)
          if event.reservation_confirmed?(current_user)
            buttons += attending_event_button 
          else
            buttons += resend_confirm_event_button(event)
          end
        else
          buttons += rsvp_event_button(event)
        end

        if ChapterMember.am_i_coordinator?(current_user.id, event.chapter.id) 
          if event.blocked?
            buttons += blocked_event_button(event)
          else
            buttons += link_to("EDIT",edit_chapter_event_path(event.chapter_id,event.id),:class => "btn-a-small flt-right") 
            buttons += cancel_event_button(event)
            buttons += delete_event_button(event) if event.can_be_deleted?
          end
        end
      end
    end
    buttons.html_safe
  end
end
