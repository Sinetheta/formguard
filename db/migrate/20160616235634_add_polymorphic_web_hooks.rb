class AddPolymorphicWebHooks < ActiveRecord::Migration
  def change
    create_table :web_hooks do |t|
      t.references :webhookable, polymorphic: true, index: true, type: :uuid
      t.string :event_type
      t.string :url
      t.boolean :active, default: true
    end
  end
end
