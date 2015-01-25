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

	def print_title(resource)
		haml_concat link_to(resource.title, collection_path(resource.collection, rid: resource.id), remote: true)
	end

	def has_embedded_or_thumbnail?(resource)
		resource.embedded_html.present? || resource.thumbnail.present?
	end

	def print_embed(resource)
		haml_concat resource.embedded_html.html_safe
	end

	def print_thumbnail(resource)
		# haml_tag :a, href: resource.url do
		haml_tag :img, class: 'display_image', src: resource.thumbnail
		# end
	end

	def print_description(resource)
		haml_concat link_to(
			get_partial_string(resource.description, 200, '...'), 
			collection_path(resource.collection, rid: resource.id), 
			remote: true
		)
	end

	def encode(string)
		URI.encode(string)
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
			# haml_tag :div, class: 'btn-square right' do
			haml_concat link_to( icon('trash'), \
				collection_resource_path(collection, resource), \
				class: 'btn-square right', \
				remote: true, \
				:'data-confirm' => "Delete resource - ”#{resource.title}” ?", :'data-modal' => true,\
				method: :delete, id: "resource_#{resource.id}")
			# end
		end

		if collection.belongs_to?(@user || current_user)
			# haml_tag :div, class: 'btn-square right' do
			haml_concat link_to(icon('edit'), edit_collection_resource_path(collection, resource), remote: true, class: 'btn-square right')
			# end
		end

		if resource.mime != 'text'
			# haml_tag :div, class: 'btn-square right' do
			haml_concat link_to(icon('globe'), resource.url, target: '_blank', class: 'btn-square right')
			# end
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

	def print_thumbnail_link(resource)
		haml_tag :a, href: collection_path(resource.collection, rid: resource.id), title: resource.title, :'data-remote' => true do
			haml_tag(:div, class: 'resourceList_preview_thumbnails_thumb', style: "background-image:url(#{resource.thumbnail})")
		end
	end

end
