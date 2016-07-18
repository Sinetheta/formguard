class FormAction < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  has_many :form_submissions
  has_many :web_hooks, as: :webhookable
  validates :name, presence: true, uniqueness: { scope: :user_id }

  include Webhookable

  def web_hook_dispatcher
    @dispatcher ||= Webhookable::Dispatcher.new(self)
  end
end
