# -*- coding: utf-8 -*-
require "open-uri"

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :get_masthead, :init_body_class, :except => [ :api_index, :api_show ]
  before_filter :protected_mode if Rails.env.test? || Rails.env.staging?

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def require_login
    if current_user.blank?
      redirect_to login_url
    end
  end

  # Used for public test environment and pre-released production to keep bots and humans out
  def protected_mode
    if current_user.blank?
      require_login
    end
  end

  def require_admin
    if current_user.blank? or current_user.is_admin.blank?
      flash[:error] = "Du saknar behörighet för detta"
      redirect_to root_path
    end
  end

  # RoutingError can't be catched here with Rack. It's matched at the bottom of the routes.rb
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  def record_not_found
    render :controller => "nursing_homes", :action => "not_found"
  end

  # Add visual cue for non-prod environments
  def init_body_class
    add_body_class("dev-env") if Rails.env.development?
    add_body_class("test-env") if  Rails.env.test? || Rails.env.staging?
  end

  # Adds classnames to the body tag
  def add_body_class(name)
    @body_classes ||= ""
    @body_classes << " user" if current_user
    @body_classes << " #{name}"
  end

  def get_masthead
    # fetch and cache masthead
    if fragment_exist? 'masthead'
      @masthead = read_fragment('masthead')
    else
      begin
        @masthead = open("https://www.malmo.se/assets-2.0/remote/external-masthead/?node=medborgare").read.strip
        if !@masthead.blank?
          write_fragment('masthead', @masthead, :expires_in => 6.hours)
        end
      rescue
        @masthead = "<!-- Couldn't fetch remote masthead-->"
        logger.warn "#{Time.now} Failed fetching masthead"
      end
    end
  end
end
