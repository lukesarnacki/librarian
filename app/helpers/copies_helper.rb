module CopiesHelper
  def reservation_user_label(user)
    text = "#{user.name}, #{user.email}"
    text += ", #{user.phone}" unless user.phone.blank?
    label_tag "check_out_user_id_#{user.id}", text
  end
end
