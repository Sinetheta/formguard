class AddTeamIdToFormAction < ActiveRecord::Migration
  def change
    add_column :form_actions, :team_id, :integer
  end
end
