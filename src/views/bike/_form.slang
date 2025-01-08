- if bike.errors
  ul.errors
    - bike.errors.each do |error|
      li = error.to_s

== form(action: "/bikes/#{bike.id.to_s}", method: bike.id ? :patch : :post) do
  == csrf_tag
  .form-group
    == text_field(name: "name", value: bike.name, placeholder: "Name", class: "form-control")
  .form-group
    == text_area(name: "prices", content: bike.prices, placeholder: "Prices", class: "form-control", size: "30x10")
  == submit("Submit", class: "btn btn-success btn-sm")
  == link_to("Back", "/bikes", class: "btn btn-light btn-sm")
