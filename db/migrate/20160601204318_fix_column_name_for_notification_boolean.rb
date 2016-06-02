class FixColumnNameForNotificationBoolean < ActiveRecord::Migration
  def change
    change_table :form_actions do |t|
      t.rename :notify_by_email?, :should_notify
    end
  end
end
