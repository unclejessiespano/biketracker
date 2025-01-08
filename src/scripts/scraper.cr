require "mechanize"
require "option_parser"
require "sqlite3"
require "json"

bike_name = ""
bike_price = ""
limit = 0
run_limit = 0

def add_price_to_bike(bike_id, price)
  time = Time.utc()
  db = get_db
  
  begin
    db.transaction do
      #get all of the prices
      prices = db.scalar "select prices from bikes where bike_id=?", bike_id || {} of String => String
      pp prices
      if prices
        # get the existing prices and convert them from json
        existing_prices = Hash(String, String).from_json(prices.to_s)
        
        # add the new price
        existing_prices[time.to_s] =  price
        updated_bike_prices = existing_prices
      else
        # the prices array doesn't exist, let's create it
        updated_bike_prices = Hash(String, String).new

        #  add the price to the array
        
        updated_bike_prices = {time.to_s=>price}
      end  
      
      # save the array to the record in the bike's table
      update_price_on_bike bike_id, updated_bike_prices.to_json

    end
  ensure
    db.close
  end
end  

def get_db
  db = DB.open("sqlite3://./db/bike_tracker_development.db")
end  

def get_or_set(bike_data)
  
  bike_id = ""
  product_id = bike_data.not_nil![:product_id]
  db = get_db

  begin
    db.transaction do
      record = db.query_one?("select bike_id from bikes where bike_id=? limit 1", product_id, as:{Int64})
      
      if record
        bike_id = record
      else
        # a record for the bike doesn't exist in the db, let's add a new one
        bike_id = save_bike bike_data
      end  
    end
  ensure
    db.close
  end

  return bike_id

end  

def get_price(bike)
  price = ""
  product_id = ""
  product_name = ""

  agent = Mechanize.new
  agent.request_headers = HTTP::Headers{"Referer" => "https://bush-daisy-tellurium.glitch.me/"}

  # get the page
  page = agent.get("https://bush-daisy-tellurium.glitch.me/")

  # find all the cards on the page
  product_cards = page.css(".product-card")

  # loop through the cards and check to make sure it belongs to the bike we want
  product_cards.each do |product_card|
    # get the headings
    headings = product_card.css(".content h3")

    # loop through the headings
    headings.each do |heading|
      if heading.inner_html == bike
        product_id = product_card.css(".content").map(&.attribute_by("data-asin")).to_a.first
        price = product_card.css(".content .price").to_a.first.inner_html
        product_name = bike
        
        # return a tuple of product data
        return {price: price, product_id:product_id, product_name:product_name}
      end
    end
  end
end

def save_bike(bike_data)
  
  db = get_db

  begin
    db.transaction do
      record = db.exec "insert into bikes (bike_id, name) values (?, ?)", bike_data.not_nil![:product_id], bike_data.not_nil![:product_name]
      
      if record
        #bike_id = db.scalar("select last_insert_rowid()")
        return bike_data.not_nil![:product_id]
      else
        # a record for the bike doesn't exist in the db, let's add a new one
        puts "save_bike ERROR - adding a bike"
      end  
    end
  ensure
    db.close
  end
end  

def save_price(bike_data)
  
  db = get_db
  bike_id = get_or_set bike_data
  
  begin
    db.transaction do
      #insert the price into the prices table
      db.exec "insert into prices (bike_id, price) values (? , ?)", bike_id, bike_data.not_nil![:price]
      
      add_price_to_bike bike_id, bike_data.not_nil![:price]

      puts "Bike ID #{bike_id} - Price Saved: #{bike_data.not_nil![:price]}"
    end
  ensure
    db.close
  end
end

def scrape_data(bike_name)
  #scrape the bike data
  bike_data = get_price bike_name
    
  #save the price of the bike
  save_price bike_data
end  

def update_price_on_bike(bike_id, prices)
  db = get_db

  begin
    db.transaction do
      #insert the price into the prices table
      db.exec "update bikes set prices = ? where bike_id = ?", prices, bike_id
      
      puts "Bike ID #{bike_id} - Prices updated"
    end
  ensure
    db.close
  end
end  

OptionParser.parse do |parser|
  parser.on "-v", "--version", "Show version" do
    puts "version 1.0"
    exit
  end
  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end
  parser.on "-b BIKE", "--bike=BIKE", "Scrapes content for specific bike" do |bike|
    bike_name = bike
  end
  parser.on "-l LIMIT", "--limit=LIMIT", "Sets a limit for the number of times the scraper should run" do |limit|
    run_limit = limit
  end
end

unless bike_name.empty?
  if run_limit == 0
    #there is no limit, scrape the data every X seconds until the script is stopped
    loop do
      scrape_data bike_name
  
      sleep 60.seconds
    end  
  else
    #convert the run_limit to an integre
    run_limit_i = run_limit.to_i

    # there is a limit. Stop scraping after X rounds
    counter = 0
    
    while counter < run_limit_i
      scrape_data bike_name

      counter += 1
      puts "Count: #{counter}"
    end
  end  
else
  puts "Please add a bike name using the -b flag. Acceptible values include the following:"
  puts "-b AW E-Bike Yellow"
  puts "-b AW SuperFast Roadster"
  puts "-b AW Stealth TT"
end