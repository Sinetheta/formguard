class AddNotificationBooleanToFormAction < ActiveRecord::Migration
  def change
    add_column :form_actions, :notify_by_email?, :boolean, default: false
  end
end
