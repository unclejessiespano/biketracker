class HomeController < ApplicationController
  def index
    bikes = Bike.all
    
    render "index.slang"
  end
end