Paperclip::Attachment.default_options.update({
  # Safe filenames
  :url  => "/system/:attachment/:id_:style.:content_type_extension"
})
