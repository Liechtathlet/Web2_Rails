module ApplicationHelper
  def hidden_div_if(condition, attributes = {}, &block)

    if condition
      attributes["style"] = "display: none"
    end
    content_tag("div", attributes, &block)
  end

  def flash_class(level)
    case level
    when :notice then "alert alert-info"
    when :success then "alert alert-success"
    when :error then "alert alert-error"
    when :alert then "alert alert-error"
    end
  end

  def field_class(resource,classes, field_name)
  
    if field_name.nil?
      if resource.errors.any?
        return classes + " has-error".html_safe
      else
        return classes.html_safe
      end
    else
      if resource.errors[field_name].any?
        return classes + " has-error".html_safe
      else
        return classes.html_safe
      end
    end
  end
end