class SessionsController < ApplicationController
  def update
    session_sidebar = session[:sidebar] || {}
    session[:sidebar] = session_sidebar.merge(params[:sidebar])
    head :ok
  end
end
