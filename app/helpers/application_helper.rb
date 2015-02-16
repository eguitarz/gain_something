module ApplicationHelper
  def html_title(title="Collk")
    content_for :title, title.to_s
  end

  def html_description(description)
    content_for :description, description.to_s.first(255)
  end

end