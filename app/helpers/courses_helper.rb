module CoursesHelper
	def self.markdown_to_html(content)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})
    markdown.render(content || '')
  end
end
