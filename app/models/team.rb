class Team < ActiveRecord::Base
  has_many :form_actions
  has_many :memberships
  has_many :members, through: :memberships

  resourcify
end
