module CoursesHelper

	def course_subtitle(course)
		haml_tag :div, class: 'subtitle' do
			haml_tag :a, href: "#{user_path(course.user.id)}" do
				haml_concat course.user.name
			end
		end
	end

	def difficulty_btn(difficulty, isSelected=false)
		btn_class = 'btn-large btn-difficulty'
		btn_class += ' selected' if isSelected
		haml_tag :button, class: btn_class, :'data-difficulty' => difficulty.downcase() do
			haml_concat difficulty
		end
	end

	def markdown_to_html(content)
		options = {fenced_code_blocks: true, disable_indented_code_blocks: true, prettify: true}
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
    markdown.render(content || '')
  end
end
