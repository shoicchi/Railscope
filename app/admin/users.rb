ActiveAdmin.register User do
  permit_params :name, :profile, :grade, :provider, :uid, :e_mail, :encrypted_password, :is_member, :holding_point, :is_delivery, :fee_category, :phone_number, :is_deleted
  #activeadminのdashboardから登録編集削除するためのおストロングパラメーター

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
