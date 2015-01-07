module CollectionsHelper
  def collection_subtitle(collection, show_user=true)
    haml_tag :div, class: 'subtitle' do

      if collection.description.present?
        haml_tag :div, class: 'collection_subtitle_description' do
          haml_tag :a, href: "#{collection_path(collection.id)}" do
            haml_concat collection.description
          end
        end
      end

      if show_user
        haml_tag :a, href: "#{user_path(collection.user.username)}" do
          haml_concat collection.user.name
        end
        haml_concat ' · '
      end

      haml_concat "#{collection.resources.count} items"
    end
  end

  def difficulty_btn(difficulty, isSelected=false)
    btn_class = 'btn-large btn-difficulty'
    btn_class += ' selected' if isSelected
    haml_tag :button, class: btn_class, :'data-difficulty' => difficulty.downcase() do
      haml_concat difficulty
    end
  end 

  def is_user_controller?(controller)
    controller == 'users'
  end

  def print_collection_create_button(collection)
    haml_concat link_to('<div class="btn-large btn-success">Create Collection</div>'.html_safe, new_collection_path, class: 'right')
  end

  def print_collection_delete_button(collection)
    if collection.belongs_to? current_user
      haml_concat link_to( \
        "<div class=\"btn-large btn-delete\">Delete Collection</div>".html_safe, \
        collection_path(collection.id), method: :delete, \
        :'data-confirm' => "Delete collection - “#{collection.name}” ?", \
        class: 'right', id: "collection-#{collection.id}" \
      )
    end
  end
end
