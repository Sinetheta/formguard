class AddNotificationBooleanToFormAction < ActiveRecord::Migration
  def change
    add_column :form_actions, :should_notify, :boolean, default: false
  end
end
