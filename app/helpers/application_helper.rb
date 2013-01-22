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


end
