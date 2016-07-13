require "rails_helper"

RSpec.describe "FormActionPresenter" do
  let(:action) { create(:form_action) }
  let(:decorated_action) { FormActionPresenter.new(action) }

  describe "#example_tag" do
    subject { decorated_action.example_tag }

    it "makes the correct tag base" do
      expect(subject).to match(/<form accept-charset="UTF-8" action="[^"]*" method="POST">/)
    end
  end

  describe "build_form_uri" do
    subject { decorated_action.build_form_uri }

    it "uses valid compenents" do
      expect{ subject }.not_to raise_error
    end

    it "returns a valid URI" do
      expect{ subject }.not_to raise_error
    end

  end

end
