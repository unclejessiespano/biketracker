

h1 = bike.name

p
  == link_to("Refect Data", "/bikes/#{bike.id}/refetch", class: "btn btn-success btn-sm")
  

canvas#chart

javascript:
    const lineChart = document.getElementById('chart')
    new Chart(lineChart, {
      type: 'line',
      data:{
        labels:#{keys},
        datasets:[{
          label:"#{bike.name}",
          data:#{values},
          fill:false,
          borderColor: 'rgb(75, 192, 192)',
          tension:0.1
        }]
      }
    });

    