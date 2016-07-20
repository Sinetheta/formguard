require 'faker'

# Dev user login: demo@example.com, password: demodata
def user_create
  @dev_user = User.create(email: 'demo@example.com', password: 'demodata', password_confirmation: 'demodata')
end

def team_create
  team = Team.create(name: Faker::Team.name)

  10.times do
    user = User.create(email: Faker::Internet.email, password: 'password', password_confirmation: 'password')
    team.members << user
  end

  team.members << @dev_user
  @dev_user.add_role :owner, team
  @dev_user.add_role :admin, team
  team.members[1].add_role :admin, team

  5.times do
    form_action = team.form_actions.create(name: Faker::Book.title)
    50.times do
      form_action.form_submissions.create(created_at: Faker::Time.between(30.days.ago, Date.today, :all))
    end
  end
end

def user_forms_create
  5.times do
    form_action = FormAction.create(name: Faker::Book.title, user: @dev_user)
    50.times do
      form_action.form_submissions.create(created_at: Faker::Time.between(30.days.ago, Date.today, :all))
    end
  end
end

user_create
team_create
user_forms_create
