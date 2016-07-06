class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :create, [FormAction, FormSubmission, WebHook, Team]
    can :read, [FormAction, FormSubmission, WebHook], user_id: user.id
    can :read, [FormAction, FormSubmission, WebHook], team: { id: user.team_ids }
    can :update, [FormAction], user_id: user.id
    can :read, Team do |t|
      user.team_ids.include? t.id
    end

  end
end
