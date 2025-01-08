class Bike < Granite::Base
  connection sqlite
  table bikes

  has_many prices : Price

  column id : Int64, primary: true
  column name : String?
  column prices : String?
end