class AddAttachmentToFormSubmission < ActiveRecord::Migration
  def change
    add_column :form_submissions, :attachment, :binary
    add_column :form_submissions, :attachment_name, :string
    add_column :form_submissions, :attachment_type, :string
  end
end
