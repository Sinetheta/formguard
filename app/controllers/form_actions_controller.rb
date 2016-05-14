class FormActionsController < ApplicationController
  def show
    @form_action = FormAction.find(params[:id])
  end
end
