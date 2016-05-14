class CreateFormSubmissions < ActiveRecord::Migration
  def change
    create_table :form_submissions do |t|
      t.references :form_action, index: true, type: :uuid
      t.hstore :payload

      t.timestamps null: false
    end
  end
end
