# frozen_string_literal: true

ActiveAdmin.register NoteHashtag do
  permit_params :note_id, :hashtag_id # activeadminのdashboardから登録編集削除するためのおストロングパラメーター

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
