class FormSubmission < ActiveRecord::Base
  belongs_to :form_action
  store_accessor :payload
end
