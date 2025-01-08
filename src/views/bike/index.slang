.row
  .col-sm-11
    h2 Bikes
  .col-sm-1
    a.btn.btn-success.btn-sm href="/bikes/new" New
.table-responsive
  table.table.table-striped
    thead
      tr
        th Name
        th Actions
    tbody
      - bikes.each do |bike|
        tr
          td = bike.name
          td
            span
              == link_to("Show", "/bikes/#{bike.id}", class: "btn btn-info btn-sm")
              == link_to("Edit", "/bikes/#{bike.id}/edit", class: "btn btn-success btn-sm")
              == link_to("Delete", "/bikes/#{ bike.id }?_csrf=#{csrf_token}", "data-method": "delete", "data-confirm": "Are you sure?", class: "btn btn-danger btn-sm")
