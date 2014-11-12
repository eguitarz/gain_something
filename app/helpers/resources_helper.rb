module ResourcesHelper
	def resource_icon(mime)
		classes = 'icon'
		content = ''
		
		case mime
		when 'text'
			content = 'T'
		when 'video'
			content = 'V'
			classes += ' photoshop'
		when 'link'
			content = 'L'
			classes += ' illustrator'
		else
		end

		haml_tag :div, :class => classes do
			haml_concat content
		end
	end
end
