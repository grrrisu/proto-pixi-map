class Game.MapData

  constructor: () ->
    @dataSets = [];

  setupData: (callback) =>
    Game.main.apiCaller.get '/spec/fixtures/map.json', (data) =>
      data = JSON.parse(data);
      @addDataSet(data);
      callback();

  addDataSet: (data) =>
    data['x2'] = data.x + data['view'][0].length - 1;
    data['y2'] = data.y + data['view'].length - 1;
    @dataSets.push(data);

  removeDataSet: (x, y) =>
    # how to identify packages

  getVegetation: (rx, ry) =>
    return @_getField(rx, ry)['vegetation'];

  mapMovedTo: (rx, ry) =>
    @rx = rx;
    @ry = ry;

  # private

  _getField: (rx, ry) ->
    rx = @rx + rx
    ry = @ry + ry
    dataSet = @_getDataSet(rx, ry);
    if dataSet?
      return dataSet['view'][ry - dataSet.y][rx - dataSet.x];
    else
      console.log("no data set for #{rx}, #{ry}");

  _getDataSet: (rx, ry) =>
    @dataSets.find (dataSet) ->
      return dataSet.x <= rx && dataSet.x2 >= rx && dataSet.y <= ry && dataSet.y2 >= ry;