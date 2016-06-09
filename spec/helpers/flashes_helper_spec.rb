require "rails_helper"

describe FlashesHelper do
  describe "#user_facing_flashes" do
    before do
      flash[:other] = :bad_val
      flash[:alert] = :test
      flash[:error] = :test
      flash[:notice] = :test
      flash[:success] = :test

    end

    subject{ user_facing_flashes }

    it "should remove all unwanted key:value pairs" do
      expect(subject.keys).to contain_exactly("alert", "error", "notice", "success")
    end

  end
end
