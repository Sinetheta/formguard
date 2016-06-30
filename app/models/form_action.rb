class FormAction < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  has_many :form_submissions
  validates :name, presence: true, uniqueness: { scope: :user_id }
end
