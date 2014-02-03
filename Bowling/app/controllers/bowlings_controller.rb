class BowlingsController < ApplicationController
  before_filter :authenticate_player!
end
