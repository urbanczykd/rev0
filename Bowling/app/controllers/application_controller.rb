class ApplicationController < ActionController::Base
  #protect_from_forgery


  def after_sign_in_path_for(player)
    bowling_path
  end

  def after_sign_out_path_for(player)
    root_path
  end


end
