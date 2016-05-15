class AddUserRefToFormActions < ActiveRecord::Migration
  def change
    add_reference :form_actions, :user, index: true, foreign_key: true
  end
end
