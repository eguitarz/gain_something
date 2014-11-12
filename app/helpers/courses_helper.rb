module CoursesHelper

	def course_subtitle(course)
		# = "<a href=\"#{user_path(c.user.id)}\">#{c.user.name}</a> • #{c.difficulty} • #{c.resources.count} items".html_safe
		haml_tag :div, class: 'subtitle' do
			haml_tag :a, href: "#{user_path(course.user.id)}" do
				haml_concat course.user.name
			end
			if course.difficulty.present?
				haml_concat " • #{course.difficulty}"
			end
			haml_concat  " • #{course.resources.count} items"
		end
	end

	def self.markdown_to_html(content)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})
    markdown.render(content || '')
  end
end
