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

		haml_tag :div, class: 'btn-resource' do
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

	def print_resource_tools(collection, resource, resource_counter)
		if collection.belongs_to?(current_user)
			haml_tag :div, class: 'btn-square right' do
				haml_concat link_to( icon('trash'), \
					collection_resource_path(collection, resource), \
					remote: true, \
					:'data-confirm' => "Delete resource - ”#{resource.title}” ?", \
					method: :delete, class: 'right', id: "resource_#{resource.id}")
			end
		end

		haml_tag :div, class: 'btn-square right' do
			haml_concat link_to(icon('eye'), collection_resource_path(collection, resource), remote: true, class: 'right embed', id: "resource_#{resource_counter}", :"data-mime" => resource.mime, :'data-base-url' => collection_path(@collection.id, p: 1, idx: resource_counter))
		end

		if resource.mime == 'text' && collection.belongs_to?(current_user)
			haml_tag :div, class: 'btn-square right' do
				haml_concat link_to(icon('edit'), edit_collection_resource_path(collection, resource), class: 'right')
			end
		end

	end

	def get_partial_string(string, limit, tail)
		concated_string = string.first(limit)
		if concated_string.length < string.length
			concated_string + tail
		else
			concated_string
		end 
	end

	def print_resource_digest(resource, limit, tail)
		link = resource.is_fulltext? ? collection_resource_path(resource.collection, resource) : resource.url
		haml_concat link_to(get_partial_string(resource.description, 200, '...'), link)
	end

end
