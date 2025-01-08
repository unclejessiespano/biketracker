# Bike Tracker

## Requirements
* Scrape the price for the "AW SuperFast Roadster" on AW Bicycles once every 60 seconds

    * Save the price to a SQLite database table, along with the date and time it was scraped
    * Run the scraper just long enough to populate some data in the table, but it's not required to keep the scraper running
* Create an HTTP web server that serves up an index page
    * The page should display a line graph depicting every scraped price over time
    * A button should be available on the page to manually trigger a new scrape
* Use the Crystal programming language for the scraper and HTTP server
* Use SQLite for the database

### Additions to the requirements

I wanted to add some flexibility to the application. Buyers are often indecisive. I built the ability to scrape each of the bikes based on a flag passed to the script doing the scraping. 

By default, the script will run every 60 seconds. I wanted an option to allow it to run X times as well. I added a flag that allows the script to run a finite number of times. This is helpful when requesting additional data points as it allows me to use the same script through the application.

## Architecture Decisions

I create two models: one for the bikes and one for the prices. 

### Bike
The schema for the bikes table 

```
  id INTEGER NOT NULL PRIMARY KEY,
  bike_id INTEGER,
  name VARCHAR,
  prices TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL

```

The prices column contains a json object of date:price key value pairs. I wanted to store the data points for the line chart in json to save a queries to the database each time the chart was rendered.

### Price
The schema for the price table

```
  id INTEGER NOT NULL PRIMARY KEY,
  bike_id INTEGER,
  price INTEGER,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL

```

I chose to store the prices in a seperate table so I could have some flexibility if I wanted access to them for a future enhancement (getting the average price, predicting trends, alerting the user when to buy, etc.). Storing the scraped prices in a table gives me flexibility to work with the data as needed.

### Amber Framework
I chose the Amber framework to streamline development and allow me to leverage the MVC pattern. I was primarily concerned about scraping the data and displaying it properly. I didn't want to spend much time on routing, layouts, or CRUD activities.

### Scraper.cr
The scraper.cr file (/src/scripts/scraper.cr) does all of the data scraping. I wanted the ability to run this from a command line. In order to reuse code and not repeat functionality, I'm calling the methods in this file when I refetch data from the bike frontend.

#### Scraping Flow
1. The user runs the scraper.cr script and passes a -b and possibly an -l flag. The -b flag allows the user to specify the bike to scrape data for, the -l flag limits the number of times the scraper will run. If a limit is not passed, the scraper will run once every 60 seconds until the script is stopped.
    
    The following script tells the scraper to find data for the "AW Stealth TT" and scrape data every 60 seconds.

    ```
    crystal run ./src/scripts/scraper.cr -- -b "AW Stealth TT"
    ```
2. Once the scraper finds the bike, it scrapes the bike_id, price, and adds it to tuple along with the bike_name.
3. The data is then passed to the **save_price** method
4. The **save_price** method gets or sets the bike in the database. I wanted to ensure there was only one instance of the bike in the bike table. The method checks to see if a bike with a product_id exists in the database. If it does, it returns it. It it doesn't, it creates a bike in the table and returns the newly added bike.
5. Once the method has the bike it, it inserts the price into the prices table and then pushes the date=>price key/value pair onto the json object in the price column of the bikes table.
6. The process is now complete and will start all over until a) the script is stopped or b) the limit has been reached

## Resources used to learn Crystal
* http://crystal-lang.org
* https://docs.amberframework.org/amber
* https://github.com/crystal-lang/crystal-sqlite3
* https://github.com/jeromegn/slang
* Stack Overflow
* Chat GPT


