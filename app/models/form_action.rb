class FormAction < ActiveRecord::Base
  has_many :form_submissions
  validates :name, presence: true
end
