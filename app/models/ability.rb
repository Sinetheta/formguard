class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new 
    can :create, [FormAction, FormSubmission]
    can :read, [FormAction, FormSubmission], user_id: user.id
    can :read, [FormAction, FormSubmission], team: { id: user.team_id } 
  end
end
