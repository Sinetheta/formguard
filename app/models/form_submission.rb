class FormSubmission < ActiveRecord::Base
  belongs_to :form_action
  store_accessor :payload
  scope :until_date, -> (date) { where("created_at <= ?", date) }
  scope :from_date, -> (date) { where("created_at >= ?", date) }
  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }
end
