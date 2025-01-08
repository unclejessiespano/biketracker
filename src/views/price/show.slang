h1 Show Price
p = price.bike_id
p = price.price
p
  == link_to("Back", "/prices", class: "btn btn-light btn-sm")
  == link_to("Edit", "/prices/#{price.id}/edit", class: "btn btn-success btn-sm")
  == link_to("Delete", "/prices/#{price.id}?_csrf=#{csrf_token}", "data-method": "delete", "data-confirm": "Are you sure?", class: "btn btn-danger btn-sm")
