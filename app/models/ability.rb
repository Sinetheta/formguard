class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new 
    can :create, [FormAction, FormSubmission, Team]
    can :read, [FormAction, FormSubmission], user_id: user.id
    can :read, [FormAction, FormSubmission], team: { id: user.team_ids }
    can :read, Team do |t|
      user.team_ids.include? t.id
    end

  end
end
