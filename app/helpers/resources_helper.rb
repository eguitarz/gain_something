module ResourcesHelper
	def resource_icon(mime)
		content = ''
		
		case mime
		when 'text'
			content = 'T'
		when 'video'
			content = icon('video-camera')
		when 'link'
			content = icon('link')
		else
		end

		haml_tag :div, class: 'icon' do
			haml_concat html_escape(content)
		end
	end
end
