# -*- coding: utf-8 -*-

module ApplicationHelper

  # Called from a partial to make it possible to use titles based on the content together with actions caching
  def page_title
    if !@nursing_home.blank?
      "#{@nursing_home.name} - #{APP_CONFIG["title_suffix"]}"
    elsif params[:action] == "compare"
      "Jämför - #{APP_CONFIG["title_suffix"]}"
    else
      APP_CONFIG["title_suffix"]
    end
  end

  def contact_data
    data = {}
    unless @nursing_home.blank?
      %w(name email phone fax address neighborhood url post_code postal_town).each do |field|
        data[field.to_s] = @nursing_home[field.to_sym].blank? ? false : @nursing_home[field.to_sym]
      end
    end
    data
  end

  def delete_icon_text
    raw "#{content_tag(:span, nil, class: 'icon-trash icon-large')} Radera"
  end

  def add_icon_text
    raw "#{content_tag(:span, nil, class: 'icon-plus')} Skapa nytt"
  end
end
