class WidgetController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout 'widget'

  def show
    @election = Election.find(params[:id])
    @show_election = !params[:show_election]
    @show_votes = !params[:show_votes]
  end
end