.row
  .col-sm-11
    h2 Prices
  .col-sm-1
    a.btn.btn-success.btn-sm href="/prices/new" New
.table-responsive
  table.table.table-striped
    thead
      tr
        th Bike_id
        th Price
        th Actions
    tbody
      - prices.each do |price|
        tr
          td = price.bike_id
          td = price.price
          td
            span
              == link_to("Show", "/prices/#{price.id}", class: "btn btn-info btn-sm")
              == link_to("Edit", "/prices/#{price.id}/edit", class: "btn btn-success btn-sm")
              == link_to("Delete", "/prices/#{ price.id }?_csrf=#{csrf_token}", "data-method": "delete", "data-confirm": "Are you sure?", class: "btn btn-danger btn-sm")
