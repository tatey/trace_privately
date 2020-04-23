module Admin::SubmissionsHelper
  def result_class(result)
    case result
    when "pending" then "is-dark"
    when "positive" then "is-danger"
    when "negative" then "is-success"
    else ""
    end
  end
end
