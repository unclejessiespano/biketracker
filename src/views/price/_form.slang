- if price.errors
  ul.errors
    - price.errors.each do |error|
      li = error.to_s

== form(action: "/prices/#{price.id.to_s}", method: price.id ? :patch : :post) do
  == csrf_tag
  .form-group
    == text_field(name: "bike_id", value: price.bike_id, placeholder: "Bike_id", class: "form-control")
  .form-group
    == text_field(name: "price", value: price.price, placeholder: "Price", class: "form-control")
  == submit("Submit", class: "btn btn-success btn-sm")
  == link_to("Back", "/prices", class: "btn btn-light btn-sm")
