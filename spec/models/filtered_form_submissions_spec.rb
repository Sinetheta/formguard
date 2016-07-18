require 'rails_helper'

RSpec.describe FilteredFormSubmission, type: :model do
  it { is_expected.to validate_presence_of(:form_action) }

  context "when built with a bad date input" do
    let(:filtered) { FilteredFormSubmission.new(start_date:"bad") }

    before(:each) { filtered.valid? }

    subject { filtered.valid? }

    it { is_expected.to eq(false) }

    it "adds an error message" do
      expect(filtered.errors.messages[:start_date].size).to eq(1)
    end
  end

  context "when built with a negative date window" do
    let(:filtered) { FilteredFormSubmission.new(start_date:"2001-1-1", end_date: "2000-1-1") }

    before(:each) { filtered.valid? }

    subject { filtered.valid? }

    it { is_expected.to eq(false) }

    it "adds an error message" do
      expect(filtered.errors.messages[:base].size).to eq(1)
    end

    it "doesn't add error messages to the :start_date" do
      expect(filtered.errors.messages[:start_date]).to be_nil
    end

    it "doesn't add error messages to the :end_date" do
      expect(filtered.errors.messages[:end_date]).to be_nil
    end

  end
end
