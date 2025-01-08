class BikeController < ApplicationController
  getter bike = Bike.new

  before_action do
    only [:show, :edit, :update, :destroy, :refetch] { set_bike }
  end

  def index
    bikes = Bike.all
    render "index.slang"
  end

  def show
    
    labels = [] of String
    prices = [] of String

    #get the prices column from the bikes table.
    bike_prices = bike.prices
    
    if bike_prices.is_a?(String)
      begin
        prices_hash = Hash(String,String).from_json(bike_prices)
        
        keys = prices_hash.keys
        values = prices_hash.values.map{ |price| price.gsub("$", "").gsub(",","").to_f}

        pp keys
        pp values
      end  
    end  
    
    render "show.slang"
  end

  def new
    render "new.slang"
  end

  def edit
    render "edit.slang"
  end

  def create
    bike = Bike.new bike_params.validate!
    if bike.save
      redirect_to action: :index, flash: {"success" => "Bike has been created."}
    else
      flash[:danger] = "Could not create Bike!"
      render "new.slang"
    end
  end

  def update
    bike.set_attributes bike_params.validate!
    if bike.save
      redirect_to action: :index, flash: {"success" => "Bike has been updated."}
    else
      flash[:danger] = "Could not update Bike!"
      render "edit.slang"
    end
  end

  def destroy
    bike.destroy
    redirect_to action: :index, flash: {"success" => "Bike has been deleted."}
  end

  private def bike_params
    params.validation do
      required :name
      required :prices
    end
  end

  private def set_bike
    @bike = Bike.find! params[:id]
  end

  def refetch
    bike_name = bike.name
    process = Process.run("crystal", ["run", "src/scripts/scraper.cr", "--", "-b", "#{bike.name}", "-l", "1"]) 

    if process.success?
      flash[:success] = "New price added."
    else
      flash[:error] = "Process encounted an error"
    end
    
    redirect_to "/bikes/#{bike.id}"
  end  
end