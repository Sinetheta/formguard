class AddReadUnreadStatusToFormSubmissions < ActiveRecord::Migration
  def change
    add_column :form_submissions, :read, :boolean, default: false
  end
end
