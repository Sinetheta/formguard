require 'net/http'
require 'uri'
require 'json'

class WebHook < ActiveRecord::Base
  belongs_to :webhookable, polymorphic: true
  validates :url, presence: true, url: true
  validates :event_type, presence: true
end
