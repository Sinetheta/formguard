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

  def embeddable_form(example_tag)
    "#{example_tag}
      <fieldset>
        <legend>Personal information:</legend>
        First name:<br>
        <input type='text' name='firstname'><br>
        Last name:<br>
        <input type='text' name='lastname'><br>
        Email:<br>
        <input type='text' name='email'><br><br>
        Upload a file:<br>
        <input name='file-upload' class='input-file' type='file'><br><br>
        <input type='submit' value='Submit'>
      </fieldset>
    </form>"
  end
end
