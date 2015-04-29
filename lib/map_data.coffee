class Game.MapData

  constructor: () ->
    @dataSets = [];

  initMap: (fieldWidth, fieldHeight, callback) =>
    Game.main.apiCaller.get '/spec/fixtures/init_map.json', (data) =>
      data = JSON.parse(data);
      @rx = data.headquarter.x - Math.floor(fieldWidth / 2);
      @ry = data.headquarter.y - Math.floor(fieldHeight / 2);
      @setupData(callback);

  setupData: (callback) =>
    @dataLoadedcallback = callback;
    @dataToLoad = 4;

    dataX = Math.floor(@rx / 10) * 10
    dataY = Math.floor(@ry / 10) * 10

    for x in [0, 10]
      for y in [0, 10]
        px = x + dataX;
        py = y + dataY;
        Game.main.apiCaller.get "/spec/fixtures/map_#{px}_#{py}.json", (data) =>
          @addDataSet(data);
          @setupDataLoaded(px, py);

  setupDataLoaded: () =>
    @dataToLoad -= 1;
    if @dataToLoad == 0
      @dataLoadedcallback();

  addDataSet: (data) =>
    data = JSON.parse(data);
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
