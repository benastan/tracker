class FilePreviewsController < ApplicationController
  def show
    raise ActionController::RoutingError unless Rails.env.in? %w[development test]
    render text: IO.read(params[:file])
  end
end
