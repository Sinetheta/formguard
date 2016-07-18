class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :manage, FormAction, user_id: user.id
    can :create, [FormSubmission, WebHook, Team]
    can :read, [WebHook], user_id: user.id
    can :read, [FormAction, WebHook], team: { id: user.team_ids }
    can [:update, :read], FormSubmission do |sub|
      user.form_actions.include? sub.form_action
    end
    can [:update, :read], FormSubmission do |sub|
      user.team_ids.include? sub.form_action.team_id
    end
    can :read, Team do |t|
      user.team_ids.include? t.id
    end

    can :manage, Team, id: user.new_record? ? [] : Team.with_role("owner", user).pluck(:id)
    can :destroy, Membership, team_id: user.new_record? ? [] : Team.with_role("admin", user).pluck(:id)
    can [:make_admin, :remove_admin], Team, id: user.new_record? ? [] : Team.with_role("admin", user).pluck(:id)
  end
end
