class FilePreviewsController < ApplicationController
  def show
    render text: IO.read(params[:file])
  end
end
