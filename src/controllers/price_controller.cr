class PriceController < ApplicationController
  getter price = Price.new

  before_action do
    only [:show, :edit, :update, :destroy] { set_price }
  end

  def index
    prices = Price.all
    render "index.slang"
  end

  def show
    render "show.slang"
  end

  def new
    render "new.slang"
  end

  def edit
    render "edit.slang"
  end

  def create
    price = Price.new price_params.validate!
    if price.save
      redirect_to action: :index, flash: {"success" => "Price has been created."}
    else
      flash[:danger] = "Could not create Price!"
      render "new.slang"
    end
  end

  def update
    price.set_attributes price_params.validate!
    if price.save
      redirect_to action: :index, flash: {"success" => "Price has been updated."}
    else
      flash[:danger] = "Could not update Price!"
      render "edit.slang"
    end
  end

  def destroy
    price.destroy
    redirect_to action: :index, flash: {"success" => "Price has been deleted."}
  end

  private def price_params
    params.validation do
      required :bike_id
      required :price
    end
  end

  private def set_price
    @price = Price.find! params[:id]
  end
end
