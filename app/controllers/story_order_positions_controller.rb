class StoryOrderPositionsController < ApplicationController
  respond_to :json

  def update
    story_order_position = StoryOrderPosition.find(params[:id])
    new_position = permitted_params.fetch(:story_order_position).fetch(:position)
    story_order_position.insert_at(new_position)
    head :ok
  end

  protected

  def permitted_params
    params.permit(story_order_position: :position)
  end
end
