class Price < Granite::Base
  connection sqlite
  table prices

  belongs_to bike : Bike

  column id : Int64, primary: true
  column bike_id : Int64?
  column price : Int64?
end
