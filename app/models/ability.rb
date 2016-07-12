class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :create, [FormAction, FormSubmission, WebHook, Team]
    can :read, [FormAction, FormSubmission, WebHook], user_id: user.id
    can :read, [FormAction, FormSubmission, WebHook], team: { id: user.team_ids }

    can :read, Team do |t|
      user.team_ids.include? t.id
    end

    can :manage, Team, id: user.new_record? ? [] : Team.with_role("owner", user).pluck(:id)
    can :destroy, Membership, team_id: user.new_record? ? [] : Team.with_role("admin", user).pluck(:id)
    can [:make_admin, :remove_admin], Team, id: user.new_record? ? [] : Team.with_role("admin", user).pluck(:id)
  end
end
