class WebHooksController < ApplicationController
  include Webhookable
  before_filter :authenticate_user!

  def index
    @webhookable = find_webhookable
    @web_hooks = @webhookable.web_hooks
  end

  def show
    @webhookable = find_webhookable
    @web_hook = @webhookable.web_hooks.select{ |web_hook| web_hook.id == params[:id].to_i }[0]
  end

  def new
    @webhookable = find_webhookable
    @web_hook = @webhookable.web_hooks.new
  end

  def create
    @webhookable = find_webhookable
    @web_hook = @webhookable.web_hooks.new(web_hook_params)

    if @web_hook.save
      #redirect_to web_hook_path @web_hook
    else
      flash[:danger] = "Opps! Something went wrong"
      render "index"
    end
  end
end
