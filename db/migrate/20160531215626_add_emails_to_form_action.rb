class AddEmailsToFormAction < ActiveRecord::Migration
  def change
    add_column :form_actions, :emails, :text, array:true, default: []
  end
end
