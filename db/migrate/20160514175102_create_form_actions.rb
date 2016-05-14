class CreateFormActions < ActiveRecord::Migration
  def change
    create_table :form_actions, id: :uuid do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
