class Membership < ActiveRecord::Base
  belongs_to :team
  belongs_to :member, class_name: 'User', foreign_key: 'user_id'

  def admin?
    self.member.has_role? :admin, self.team
  end
end
