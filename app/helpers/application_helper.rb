module ApplicationHelper
  def lang
    if params[:locale] == 'CN'
      return 'zh-CN'
    else
      return params[:locale]
    end
  end

  def active_class(link, cont)
    if params[:action] == link && params[:controller] == cont
         "ulb-selected"
    elsif params[:controller].split('/')[0] == link
        "ulb-selected"
    else
       link
    end
  end

  def emails
    data = []
    User.all.each_with_index do |user,i|
       data[i] = { "label" => "#{user.email}", "value" => "#{user.id}"}
    end    
    data.to_json
  end

  def photo_display_pic(obj,type, size, path , class_name, style='')
    if obj.photo_file_name && (obj.errors[:photo_content_type].blank? && obj.errors[:photo_file_size].blank?)
      image_tag(obj.photo.url(type.to_sym), :alt => 'Pic', :size => size,:class => class_name, :style => style)
    else
      image_tag(path, :alt => 'Pic', :size => size , :class => class_name, :style => style)
    end
  end

  def avatar_display_pic(obj,type, size, path , class_name)
     if obj.avatar_file_name && (obj.errors[:avatar_content_type].blank? && obj.errors[:avatar_file_size].blank?)
      image_tag(obj.avatar.url(type.to_sym), :alt => 'Pic', :size => size,:class => class_name)
    else
      image_tag(path, :alt => 'Pic', :size => size , :class => class_name)
    end
  end

  def main_chapters(country)
    Chapter.where(:country_name => country , :chapter_status => [:active,:incubated])
  end

  # For generating time tags calculated using jquery.timeago
  def timeago(time, options = {})
    options[:class] = "timeago"
    content_tag(:abbr, time.to_s, options.merge(:title => time.getutc.iso8601)) if time
  end

  # Shortcut for outputing proper ownership of objects,
  # depending on who is looking
  def whose?(user, object)
    case object
      when Post
        owner = object.author
      when Event
        owner = object.user
      else
        owner = nil
    end
    if user and owner
      if user.id == owner.id
        "his"
      else
        "#{owner.nickname}'s"
      end
    else
      ""
    end
  end

  # Check if object still exists in the database and display a link to it,
  # otherwise display a proper message about it.
  # This is used in activities that can refer to
  # objects which no longer exist, like removed posts.
  def link_to_trackable(object, object_type)
    if object
      link_to object_type.downcase, object
    else
      "a #{object_type.downcase} which does not exist anymore"
    end
  end

  def youtube_parsed_uri(uri)
    "https://www.youtube.com/v/#{uri.split("?v=").last}?version=3&fs=1&width=600&height=360&hl=en_US1&iframe=true&rel=0"
  end
  
end
