class FormAction < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  has_many :form_submissions
  validates :name, presence: true, uniqueness: { scope: :user_id }

  def belongs_to
    self.team_id ? Team.find(self.team_id).name : User.find(self.user_id).email
  end
  has_many :web_hooks, as: :webhookable

  include Webhookable

  def web_hook_dispatcher
    @dispatcher ||= Webhookable::Dispatcher.new(self)
  end
end
