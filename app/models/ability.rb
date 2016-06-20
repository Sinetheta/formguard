class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new 
    can :create, [FormAction, FormSubmission]
    can :read, [FormAction, FormSubmission], user_id: user.id
  end
end
