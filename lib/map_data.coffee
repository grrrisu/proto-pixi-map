class Game.MapData

  constructor: (data) ->
    @dataSets = [];
    if data?
      @addDataSet(data);

  loadInitialMapData: (callback) =>
    @dataLoaded = callback
    Game.main.apiCaller.get('/spec/fixtures/init_map.json', @initLoaded);

  initLoaded: (data) =>
    Game.main.apiCaller.get '/spec/fixtures/map.json', (data) =>
      data = JSON.parse(data);
      @addDataSet(data);
      @dataLoaded();

  addDataSet: (data) =>
    data['x2'] = data.x + data['view'][0].length - 1;
    data['y2'] = data.y + data['view'].length - 1;
    @dataSets.push(data);

  removeDataSet: (x, y) =>
    # how to identify packages

  getVegetation: (rx, ry) =>
    return @_getField(rx, ry)['vegetation'];

  mapMovedBy: (dx, dy) =>
    console.log(dx, dy)

  # private

  _getField: (rx, ry) ->
    dataSet = @_getDataSet(rx, ry);
    if dataSet?
      return dataSet['view'][ry - dataSet.y][rx - dataSet.x];
    else
      console.log("no data set for #{rx}, #{ry}");

  _getDataSet: (rx, ry) =>
    @dataSets.find (dataSet) ->
      return dataSet.x <= rx && dataSet.x2 >= rx && dataSet.y <= ry && dataSet.y2 >= ry;