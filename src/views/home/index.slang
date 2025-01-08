.row.justify-content-center
  .col-sm-12.col-md-6
    h2 = "Bikes"
    p I want to ride my bicycle.
    .list-group
      - bikes.each do |bike|
        a.list-group-item.list-group-item-action href="/bikes/#{bike.id}" #{bike.name}
