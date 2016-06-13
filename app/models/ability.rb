class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, FormAction, user_id: user.id
    can :manage, FormSubmission, user_id: user.id
  end
end
