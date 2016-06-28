require 'rails_helper'

RSpec.describe WebHook, type: :model do
  context "when hook associated with a form action" do

    let (:valid_web_hook) { build(:web_hook, :valid, :on_form) }
    let (:invalid_web_hook) { WebHook.new(url:"invalid") }
    let (:web_hook) { build(:web_hook) }

    it 'defaults to nil url' do
      expect(web_hook.url).to be_nil
    end

    it 'is invalid without a url' do
      expect(web_hook).to_not be_valid
    end

    it 'is valid with an http-url' do
      expect(valid_web_hook).to be_valid
    end

    it 'is active by default' do
      expect(valid_web_hook.active).to be_truthy
    end

    it 'is invalid with a non-http url' do
      expect(invalid_web_hook).not_to be_valid
    end

  end
end
