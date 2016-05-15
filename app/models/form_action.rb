class FormAction < ActiveRecord::Base
  belongs_to :user
  has_many :form_submissions
  validates :name, presence: true
end
