module Webhookable
  WEBHOOKABLES = [{klass:FormAction, path:'forms'}]

  def current_webhookable
    path = request.fullpath
    Webhookable::WEBHOOKABLES.each do |webhookable|
      regexp = Regexp.new "^\/#{webhookable[:path]}"
      return webhookable[:klass] if path.match(regexp)
    end
    nil
  end

  def find_webhookable
    ##
    # Return the current webhookable instance

    current_webhookable.find(params[current_webhookable.name.to_s.underscore + "_id"])
  end

  def web_hook_path web_hook
    "#{request.env['PATH_INFO']}/#{web_hook.id}"
  end

  class Dispatcher
    def initialize(webhookable)
      @webhookable = webhookable
    end

    def deliver(event_type, payload)
      web_hooks = @webhookable.web_hooks.select do |web_hook|
        web_hook.event_type == event_type.to_s && web_hook.active?
      end
      web_hooks.each do |web_hook|
        post(web_hook, payload)
      end
    end

    private
    def post(web_hook, payload)
      uri = URI.parse(web_hook.url)
      request = Net::HTTP::Post.new(uri)
      request.content_type = "application/json"
      request.body = payload
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request(request)
      end
    end
  end

end
