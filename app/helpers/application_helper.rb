module ApplicationHelper
  def flash_class(key)
    case key
    when "notice" then "is-primary"
    when "alert" then "is-warning"
    else ""
    end
  end
end
