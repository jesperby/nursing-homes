# -*- coding: utf-8 -*-
include ActionView::Helpers::SanitizeHelper

class NursingHome < ActiveRecord::Base

  OWNER_TYPES = {
    "municipal" => "Kommunalt",
    "private" => "Privat"
  }
  NEIGHBORHOODS = %w[Innerstaden Norr Söder Väster Öster]

  has_many :images, :order => "position"
  has_many :attachments
  accepts_nested_attributes_for :images, :allow_destroy => true
  accepts_nested_attributes_for :attachments, :allow_destroy => true

  has_many :categorizations
  has_many :categories, through: :categorizations

  attr_accessor :images_positions

  before_save :sort_images

  before_validation do
    # Add http:// if not there
    self.url = "http://#{url}" unless url.match(/^https?:\/\//) unless url.blank?
    self.description = cleanup_markup self.description unless description.blank?
    self.standard = self.standard.gsub(/ {2,}/, " ").gsub(/\r/, "").strip unless standard.blank?
  end

  validates :name,
      :presence => { :allow_blank => false }

  validates :description, :standard, :seats, :rent, :owner_type, :address, :phone, :category_ids,
      :presence => { :allow_blank => false }, :if => "!draft"

  validate :validate_markup_as_plaintext

  validates  :standard,
      :length => { :maximum => 150 }

  validates :quality_environment, :quality_activities, :quality_food, :quality_safety, :quality_average, :quality_consideration,
      :allow_blank => true, :inclusion => { :in => 1..100, :message => " måste vara mellan 1 och 100" }

  validates :email,
    :format => {
      :allow_blank => true,
      :with => /^\S+@[\w\.]{2,}\.[a-z]{2,4}$/i,
      :message => " har fel format."
    }

  def validate_markup_as_plaintext
    # Remove markup before doing the length validation. Insert a space between an end tag and an opening tag first.
    errors.add(:description, ' är för lång') if ActionView::Helpers::SanitizeHelper::sanitize(description.gsub(/(<\/.+?>)</, "#{$1} <"), tags: %w()).gsub(/\s+/, " ").strip.length > 770
  end

  def cleanup_markup(markup)
    # clean up markup
    ActionView::Helpers::SanitizeHelper::sanitize( markup, tags: %w(p h2) ).gsub("&nbsp;", " ").gsub(/<p>\s*<\/p>/, "").gsub(/<h2>\s*<\/h2>/, "").gsub(/\s+/, " ").strip
  end

  # Override some defalts on as_json
  def as_json(options={})
    super(
      {
        :root => false,
        :methods => [ :photos, :permalink ]
      }.merge(:only => (@@params[:fields].split(",") unless @@params[:fields].blank?) ).merge(options)
    )
  end

  # Method for the API. Return one nursing home if params[:id] is specified, otherwise all
  def self.api(urls, params)
    # Some router urls from action
    @@urls = urls
    # Request params from action
    @@params = params

    if params[:id].blank?
      self.order("name asc").includes(:images)
    else
      self.includes(:images).find(params[:id])
    end
  end

  # Called from as_json, builds urls for the first image for a nursing home
  def photos
    if !self.images.blank? and (@@params[:fields].blank? or @@params[:fields].include?("photos"))
      {
        :thumbnail => { :url => File.join(@@urls[:root], self.images.first.image.url(:thumb)) },
        :medium =>    { :url => File.join(@@urls[:root], self.images.first.image.url(:medium)) },
        :large =>     { :url => File.join(@@urls[:root], self.images.first.image.url(:large)) }
      }
    end
  end

  # Called from as_json, return permalink for the nursing home page
  def permalink
    File.join(@@urls[:nursing_home], self.id.to_s )
  end

  # Returns the `limit` closest nursing homes with :id, :name and :distance
  # This method compare the current nursing home with **all** other.
  # Note: This is okey since we only have < 100 nursing homes and do the cache
  def nearby(id, limit)
    # Get or write cache

    Rails.cache.fetch("nearby-#{id}") do
      nursing_homes = NursingHome.all

      # Iterate over all other homes
      compared_nursing_homes = {}
      nursing_homes.each do |compare_with|
        unless compare_with === self or compare_with.geo_position_x.blank? or compare_with.geo_position_x.blank? or self.geo_position_x.blank? or self.geo_position_y.blank?
          # The Euclidean distance formula to get the distances
          compared_nursing_homes[compare_with.id] = {
            :name => compare_with.name,
            :distance => Math.sqrt( ( compare_with.geo_position_x - self.geo_position_x )**2 + ( compare_with.geo_position_y - self.geo_position_y )**2 )
          }
        end
      end
      # Sort by distance from current home to get the `limit` closest homes
      compared_nursing_homes.sort_by { |k, v| v[:distance] }.take(limit)
    end
  end

  private
  # Sort existing and new images based 'images_positions' in edit view
  def sort_images
    self.images_positions ||= []
    position = images_positions.length

    images.each do |image|
      # Existing image
      if images_positions.index(image.id.to_s)
        image.position = images_positions.index(image.id.to_s)
        position = position + 1
      # New image
      elsif !image.id
        image.position = position
        position = position + 1
      end
    end
  end
end
