require 'rails_helper'

RSpec.describe FormSubmissionSearch, type: :model do
  let(:action) { create(:form_action) }
  context "when intialized with a form action" do
    subject { FormSubmissionSearch.new(form_action: action) }
    it { is_expected.to validate_presence_of(:form_action) }

    context "when built with a bad date input" do
      let(:filtered) { FormSubmissionSearch.new(q: "bad from:2000-99-99", form_action: action) }

      it "raises an InvalidSearchError" do
        expect{ filtered }.to raise_error(FormSubmissionSearch::InvalidSearchError)
      end
    end

    context "when built with a negative date window" do
      let(:filtered) {
        FormSubmissionSearch.new(form_action: action,
                                 q: "from:2001-1-1 to:2000-1-1")}

      it "raises an InvalidSearchError" do
        expect{ filtered }.to raise_error(FormSubmissionSearch::InvalidSearchError)
      end
    end
  end
end
