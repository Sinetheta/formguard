require 'rails_helper'

RSpec.describe FormAction, type: :model do
  let(:form) { create(:form_action) }
  let(:example_tag) { FormActionPresenter.new(form) }
  it { is_expected.to validate_presence_of(:name) }

  describe "embeddable_form method" do
    it "creates embeddable HTML" do
      expect(form.embeddable_form(example_tag)).to_not be_empty
    end
  end
 
end
