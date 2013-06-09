# -*- coding: utf-8 -*-

class Attachment < ActiveRecord::Base
  belongs_to :nursing_home

  has_attached_file :attachment,
    :url  => "/system/:attachment/:id.:content_type_extension"

  validates_attachment_content_type :attachment,
      :content_type => ['application/pdf', 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'],
      :message => "Fel filformat. Du kan ladda upp PDF och Excel-filer."
  validates_attachment_size :attachment,
    :less_than => 1.megabyte,
    :message => "Filen får inte vara större än 1MB."

  # validates :attachment_link_text, :length => { :maximum => 100 }

  validate :link_text_required

  def link_text_required
    if !self.id && attachment_file_size.blank?
      # The record is new but not file was uploaded
      # We need to delete the object so it doesn't get validated/saved since we will have a blank text field
      self.delete
    elsif !self.id
      # New record without link text
      errors.add(:attachment_link_text, 'Bilagan saknar länktext. Ange länktexten och ladda upp bilagan igen.') if attachment_link_text.strip.empty?
    else
      # Existing record
      errors.add(:attachment_link_text, 'Bilagan saknar länktext.') if attachment_link_text.strip.empty?
      errors.add(:attachment_link_text, 'Länkttexten är för lång (maximum 60 tecken).') if attachment_link_text.strip.length > 60
    end
  end
end
