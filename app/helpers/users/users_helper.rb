module Users::UsersHelper
  def is_current_user?(user)
    user && user.id == current_user.id
  end
end
