# -*- coding: utf-8 -*-
class SessionsController < ApplicationController

  skip_filter :protected_mode
  force_ssl

  def new
    add_body_class('edit')
  end

  def create
    if User.auth(params)
      user = User.find_by_username(params["username"])
      if user
        session[:user_id] = user.id
        redirect_to root_path, :notice => "Nu är du inloggad"
      else
        flash[:alert] = "Du har inte behörighet till systemet"
        redirect_to apply_user_path
      end
    else
      flash[:alert] = "Fel användarnamn eller lösenord"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Nu är du utloggad"
    redirect_to :controller => "nursing_homes" , :action => "index", :protocol => "http"
  end
end
