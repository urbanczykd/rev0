class SpaysController < ApplicationController

  def index
  end

  def create
    return render :text => "jestem w spays #{params.to_json}"
  end

  def show
  end

end
