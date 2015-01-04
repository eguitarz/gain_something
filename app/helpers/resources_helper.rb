module ResourcesHelper
	def resource_icon(mime)
		content = ''
		
		case mime
		when 'text'
			content = 'T'
		when 'video'
			content = icon('video-camera')
		when 'link'
			content = icon('external-link')
		when 'rich'
			content = icon('link')
		when 'photo'
			content = icon('photo')
		else
			content = icon('question')
		end

		haml_tag :div, class: 'icon' do
			haml_concat html_escape(content)
		end
	end

	def print_title(resource, no_link=false)
		if no_link
			haml_concat resource.title
		else
			haml_concat link_to(resource.title, resource.url, title: resource.title)
		end
	end

	def has_embedded_or_thumbnail?(resource)
		resource.embedded_html.present? || resource.thumbnail.present?
	end

	def print_embedded_or_thumbnail(resource)
		if resource
			if resource.embedded_html.present?
				haml_concat resource.embedded_html.html_safe
			elsif resource.thumbnail.present?
				haml_concat link_to(image_tag(resource.thumbnail), resource.url)
			end
		end
	end

	def print_description(resource)
		haml_concat get_description(resource)
	end

	def get_description(resource)
		if resource && resource.description.present?
			URI.encode(resource.description)
		else 
			'' 
		end
	end
end
