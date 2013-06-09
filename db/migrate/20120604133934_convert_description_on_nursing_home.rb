class ConvertDescriptionOnNursingHome < ActiveRecord::Migration
  # Convert description on nursing
  def up
    NursingHome.all.each do |nursing_home|
      lines = nursing_home.description.gsub(/\r/, "").split(/\n/)
      description = ""

      lines.each_with_index do |line, index|

        next if line.blank? || line.match(/^$/)
        # puts line if line.match(/^$/)

        if !lines[index - 1].nil? && !!lines[index - 1].match(/^$/)
          description += "<h2>#{line.strip}</h2> "
        else
          description += "<p>#{line.strip}</p> "
        end
      end
      nursing_home.description = description
      nursing_home.save( validate: false )
    end
  end
end
