class FormAction < ActiveRecord::Base
  validates :name, presence: true
end
