module NursingHomesHelper

  # data-x attributes for each nursing home
  def data_dashes n
    {
      "data-id" => n.id,
      "data-name" => n.name,
      "data-neighborhood" => n.neighborhood,
      "data-category" => "|#{n.categories.collect(&:id).join("|")}|",
      "data-owner_type" => n.owner_type
    }
  end

  def quality_indicator(instance, param)
    content_tag(:div, class: "indicator") do
      content_tag(:div, t("nursing_home.#{param.to_s}") + ":", class: "label") +
      content_tag(:div, class: "value") do
        quality_indicator_graph(instance.send(param))
      end
    end
  end

  def compare_quality(nursing_homes, param)
    out = content_tag(:th, t("nursing_home.#{param.to_s}") + ":", class: "quality")
    nursing_homes.collect do |nursing_home|
      out += content_tag(:td, class: "item-#{nursing_home.id}") do
        quality_indicator_graph(nursing_home.send(param))
      end
    end
    out
  end

  def quality_indicator_graph(value)
    if value.present?
      content_tag(:div, class: "graph") do
        content_tag(:span, class: "satisfaction", style: "width: #{value}px") do
          content_tag(:span, "#{value}%")
        end
      end
    end
  end
end
