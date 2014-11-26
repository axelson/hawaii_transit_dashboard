$ ->
  # Vehicles registered: jbez-8d6q
  # Population by county: hnpb-2rfi
  hawaiiData = new SocrataData('hawaii')
  vehicleRequest = hawaiiData.get_dataset 'jbez-8d6q'
  populationRequest = hawaiiData.get_dataset 'hnpb-2rfi'
  $.when( vehicleRequest, populationRequest ).done (vehiclesResponse, populationResponse) ->
    vehicles = vehiclesResponse[0]
    population = populationResponse[0]

    years = _.uniq(_.flatten([vehicles, population]).map (d) -> +d.year )
    vehiclesByYear = _.reduce(vehicles, ((memo, vehicle) -> memo[+vehicle.year] = +vehicle.state_total; memo), {})
    populationByYear = _.reduce(population, ((memo, vehicle) -> memo[+vehicle.year] = +vehicle.state_total; memo), {})
    firstYear = years[0]
    vehiclesPerYear = []
    populationPerYear = []
    for year in years
      vehiclesPerYear.push (vehiclesByYear[year] || null)
      populationPerYear.push (populationByYear[year] || null)

    chart = c3.generate
      bindto: '.visualization.car-vs-people'
      data: {
        x: 'years'
        columns: [
          ['vehicles'].concat(vehiclesPerYear)
          ['population'].concat(populationPerYear)
          ['years'].concat(years)
        ]
      }

class SocrataData
  constructor: (site) ->
    @site = site

  get_dataset: (uniqueDatasetId, params={}) ->
    default_params =
      $limit: 100
    fullParams = $.extend({}, default_params, params)
    url = "https://data.#{@site}.gov/resource/#{uniqueDatasetId}.json"
    $.get url, fullParams
