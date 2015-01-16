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

	def print_title(resource, link='', with_link=true)
		if with_link
			link = link.present? ? link : resource.url
			if resource.mime == 'text'
				haml_concat link_to(resource.title, link, title: resource.title)
			else
				haml_concat link_to(resource.title, link, title: resource.title, target: '_blank')
			end
		else
			haml_concat resource.title
		end
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

	def print_description(resource, link='')
		link = resource.url unless link.present?
		haml_concat link_to(
			get_partial_string(resource.description, 200, '...'), link, target: '_blank'
		)
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
					:'data-confirm' => "Delete resource - ”#{resource.title}” ?", :'data-modal' => true,\
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

	def print_thumbnail_link(resource)
		link = resource.is_fulltext? ? collection_resource_path(resource.collection, resource) : resource.url
		thumbnail_lambda.call(resource, link)
	end

	def thumbnail_lambda
		
		lambda do |resource, link|
			haml_tag :a, href: link, title: resource.title, target: '_blank' do
				haml_tag(:div, class: 'resourceList_preview_thumbnails_thumb', style: "background-image:url(#{resource.thumbnail})")
			end
		end

	end

end
