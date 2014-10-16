ActiveAdmin.register User do
  permit_params :email, :name

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :name
    end
    f.actions
  end

end
