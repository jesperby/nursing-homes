# -*- coding: utf-8 -*-
class UsersController < ApplicationController

  before_filter { add_body_class('edit') }
  before_filter :require_admin, :except => :apply

  def index
    @users = User.order("displayname ASC")
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to users_path, :notice => "Användaren har lagts till"
    else
      render :action => "new"
    end
  end

  def destroy
    @user = User.find(params[:id])
    # Don't let an admin destroy hereself
    if @user.id === current_user.id
      flash[:error] = "En administratör kan inte ta bort sig själv"
      redirect_to users_path
    else
      @user.destroy
      redirect_to users_path, :notice => 'Användaren togs bort'
    end
  end

  # Add or remove the is_admin role to a user
  def toggle_admin
    @user = User.find(params[:id])
    # Don't let an admin un-admin hereself
    if @user.id === current_user.id
      flash[:error] = "Du kan inte ta bort administratörsrollen från dig själv"
      redirect_to users_path
    else
      @user.toggle_admin
      redirect_to users_path, :notice => "Användaren uppdaterades"
    end
  end

  # Search the LDAP for users by username
  # Return a json[p] string
  def search
    users = User.search(params[:ldap_cn])
    render :json => { :users => users }, :callback => params[:callback]
  end

  # Administrators that the user can contact, except for the developer
  def apply
    @admin_users = User.where(is_admin: true)
  end
end
