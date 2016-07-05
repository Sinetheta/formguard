class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :manage, FormAction, user_id: user.id
    can :create, [FormSubmission, WebHook, Team]
    can :read, [FormSubmission, WebHook], user_id: user.id
    can :read, [FormAction, FormSubmission, WebHook], team: { id: user.team_ids }
    can :read, Team do |t|
      user.team_ids.include? t.id
    end

  end
end
