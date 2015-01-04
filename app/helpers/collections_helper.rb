module CollectionsHelper
  def collection_subtitle(collection, show_user=true)
    haml_tag :div, class: 'subtitle' do
      
      if show_user
        haml_tag :a, href: "#{user_path(collection.user.id)}" do
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
end
