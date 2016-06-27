class Team < ActiveRecord::Base
  has_many :form_actions
  has_many :memberships
  has_many :members, through: :memberships
  has_many :invites

  resourcify

  def owner
    User.with_role(:owner, self).first
  end

  def admins
    User.with_role(:admin, self)
  end
end
