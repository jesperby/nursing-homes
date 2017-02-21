# -*- coding: utf-8 -*-

class NursingHomesController < ApplicationController

  before_filter :require_login, :only => [:new, :edit, :create, :update, :destroy]
  skip_filter :protected_mode, :only => [ :api_index, :api_show ]

  # Cache API calls with query strings
  caches_action :api_index, :api_show, :cache_path => Proc.new { |c| c.request.url }
  cache_sweeper :nursing_home_sweeper

  def index
    @nursing_homes = nursing_homes
  end

  def map
    @nursing_homes = nursing_homes
  end

  def show
    @nursing_home = NursingHome.includes(:images).includes(:attachments).find(params[:id])
    render action: "not_found" if @nursing_home.draft && !current_user
    @nearby_homes = @nursing_home.nearby(params[:id], 3)
  end

  def new
    add_body_class('edit')
    @nursing_home = NursingHome.new
    new_images
    new_attachments
  end

  def edit
    add_body_class('edit')
    @nursing_home = NursingHome.find(params[:id])
    new_images
    new_attachments
  end

  def create
    add_body_class('edit')
    @nursing_home = NursingHome.new(params[:nursing_home])

    if @nursing_home.save
      redirect_to @nursing_home, :notice => 'Äldreboendet har skapats.'
    else
      new_images
      new_attachments
      render action: "new"
    end
  end

  def update
    add_body_class('edit')
    @nursing_home = NursingHome.find(params[:id])

    if @nursing_home.update_attributes(params[:nursing_home])
      redirect_to @nursing_home, :notice => 'Äldreboendet har uppdaterats.'
    else
      new_images
      new_attachments
      render action: "edit"
    end
  end

  def destroy
    @nursing_home = NursingHome.find(params[:id])
    @nursing_home.destroy
    redirect_to nursing_homes_url, :notice => 'Äldreboendet har tagits bort.'
  end

  def compare
    add_body_class('compare')

    if cookies[:nursing_homes_compare].present?
      nursing_homes_ids = cookies[:nursing_homes_compare].gsub!(/['"]/, '').split('|')
    end
    @nursing_homes = nursing_homes_ids.blank? ?  false : NursingHome.where( :id => nursing_homes_ids )
  end

  # Return all nursing homes in json[p]
  def api_index
    render_api NursingHome.api(urls, params)
  end

  # Return params[:id] nursing home in json[p]
  def api_show
    render_api NursingHome.api(urls, params)
  end

  def not_found
    # 404 with a layout
    render :status => 404
  end

  private

  def nursing_homes
    show_draft = current_user ? {} : { draft: false } # Drafted records are for authenticated users only
    NursingHome.where(show_draft).order("name asc").includes(:images).includes(:attachments)
  end

  def new_images
    # Existing Paperclip images minus max_number_of_images
    ( APP_CONFIG["max_number_of_images"] - @nursing_home.images.length ).times { @nursing_home.images.build }
  end

  def new_attachments
    # Existing Paperclip attachments minus max_number_of_attachments
    ( APP_CONFIG["max_number_of_attachments"] - @nursing_home.attachments.length ).times { @nursing_home.attachments.build }
  end

  def urls
    {
      :root => root_url,
      :nursing_home => nursing_homes_url,
      :api => api_nursing_homes_url
    }
  end

  def render_api nursing_home
    render :json =>
    {
      :status => { :code => 200, :message => "OK" },
      :permalink => root_url,
      :permalink_api => api_nursing_homes_url,
      :generated => Time.now,
      :nursing_homes => nursing_home.as_json()
    },
    :content_type => 'application/json',
    :callback => params[:callback]
  end
end
