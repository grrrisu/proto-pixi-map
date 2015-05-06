class Game.MapData

  constructor: () ->
    @dataSets = [];

  initMap: (fieldWidth, fieldHeight, callback) =>
    Game.main.apiCaller.get '/spec/fixtures/init_map.json', (data) =>
      data = JSON.parse(data);
      console.log("hx #{data.headquarter.x} hy #hy #{data.headquarter.y}")
      @rx = data.headquarter.x - Math.floor(fieldWidth / 2);
      @ry = data.headquarter.y - Math.floor(fieldHeight / 2);
      @startX = @rx;
      @startY = @ry;
      @setupData(callback);

  setupData: (callback) =>
    @dataLoadedCallback = callback;
    @dataToLoad = 9; # initial 3 x 3
    @loadData(@setupDataLoaded);

  setupDataLoaded: () =>
    @dataToLoad -= 1;
    if @dataToLoad == 0
      @dataLoadedCallback();

  loadData: (callback) =>
    dataX = Math.ceil(@rx / 10) * 10
    dataY = Math.ceil(@ry / 10) * 10

    for x in [0, 10, -10]
      for y in [0, 10, -10]
        px = x + dataX;
        py = y + dataY;

        unless @isDataSetLoaded(px, py)
          Game.main.apiCaller.get "/spec/fixtures/map_#{px}_#{py}.json", (data) =>
            @addDataSet(data);
            if callback?
              callback();

  isDataSetLoaded: (x, y) =>
    @dataSets.any (dataSet) ->
      dataSet.x == x && dataSet.y == y

  addDataSet: (data) =>
    data = JSON.parse(data);
    data['x2'] = data.x + data['view'][0].length - 1;
    data['y2'] = data.y + data['view'].length - 1;
    @dataSets.push(data);

  removeDataSet: (x, y) =>
    # how to identify packages

  getVegetation: (rx, ry) =>
    field = @_getField(rx, ry)
    if field?
      return field['vegetation'];

  mapMovedTo: (ax, ay, fieldSize, callback) =>
    rx = Math.floor(-ax / fieldSize);
    ry = Math.floor(-ay / fieldSize);
    if @rx != rx || @ry != ry
      deltaX = rx - @rx;
      deltaY = ry - @ry;
      @rx = rx;
      @ry = ry;
      @loadData();
      callback(deltaX, deltaY);

  # private

  _getField: (rx, ry) ->
    dataSet = @_getDataSet(rx, ry);
    if dataSet?
      return dataSet['view'][ry - dataSet.y][rx - dataSet.x];
    else
      console.log("no data set for #{rx}, #{ry}");

  _getDataSet: (rx, ry) =>
    @dataSets.find (dataSet) ->
      return dataSet.x <= rx && dataSet.x2 > rx && dataSet.y <= ry && dataSet.y2 > ry;
