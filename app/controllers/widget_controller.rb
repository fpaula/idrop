class WidgetController < ApplicationController
  protect_from_forgery
  skip_before_action :verify_authenticity_token, if: :js_request?

  def show
    if params[:version] == '1.0'
      redirect_to widget_file
    else
      render nothing: true
    end
  end

  private

  def js_request?
    request.format.js?
  end

  def widget_file
    ActionController::Base.helpers.javascript_path('widget/1.0/epicvotes.js')
  end
end