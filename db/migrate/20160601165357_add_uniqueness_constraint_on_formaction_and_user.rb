class AddUniquenessConstraintOnFormactionAndUser < ActiveRecord::Migration
  def change
    add_index(:form_actions, [:name, :user_id], :unique => true)
  end
end
