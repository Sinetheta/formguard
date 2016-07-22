class AddResponseToFormAction < ActiveRecord::Migration
  def change
    add_column :form_actions, :auto_response, :text
  end
end
