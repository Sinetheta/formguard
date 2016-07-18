class Invite < ActiveRecord::Base
  belongs_to :team
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create
  before_create :generate_token

  def generate_token
    self.token = Digest::SHA1.hexdigest( [self.team_id, Time.now, rand].join )
  end

  def add_recipient_to_invite_if_user_exists
    recipient = User.find_by(email: email)
    self.recipient_id = recipient.id if recipient
  end

  def add_recipient_to_team
    if self.recipient_id
      InviteMailer.existing_user_invite(self).deliver_now
      self.team.members << self.recipient
    else
      InviteMailer.new_user_invite(self).deliver_now
    end
  end
end
