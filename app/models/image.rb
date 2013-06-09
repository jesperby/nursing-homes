# -*- coding: utf-8 -*-

class Image < ActiveRecord::Base
  belongs_to :nursing_home

  # Paperclip images. Resize, compress and strip metadata
  has_attached_file :image,
      :styles => { :large => "511x600>", :medium => "300x300>", :thumb => "144x108#" },
      :convert_options => { :large => '-quality 40 -strip', :medium => '-quality 40 -strip', :thumb => '-quality 40 -strip' }

  validates_attachment_content_type :image,
      :content_type => ['image/jpeg', 'image/pjpeg', 'image/png', 'image/gif'],
      :message => "Fel bildformat. Du kan ladda upp jpg-, png- och gif-bilder"
  validates_attachment_size :image,
    :less_than => 1.megabyte,
    :message => "Bilden får inte vara större än 1MB"
end
