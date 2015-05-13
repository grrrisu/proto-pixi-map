class Game.MapData

  constructor: () ->
    @dataSets = [];

  initMap: (fieldWidth, fieldHeight, callback) =>
    Game.main.apiCaller.get '/spec/fixtures/init_map.json', (data) =>
      data = JSON.parse(data);
      console.log("hx #{data.headquarter.x} hy #hy #{data.headquarter.y}")
      rx = data.headquarter.x - Math.floor(fieldWidth / 2);
      ry = data.headquarter.y - Math.floor(fieldHeight / 2);
      @setDataPosition(rx, ry);
      @setupData(callback);

  setupData: (callback) =>
    @dataLoadedCallback = callback;
    @dataToLoad = 9; # initial 3 x 3
    @loadData(@setupDataLoaded);

  setupDataLoaded: () =>
    @dataToLoad -= 1;
    if @dataToLoad == 0
      @dataLoadedCallback();

  currentView: () =>
    return [[@dataX - 10, @dataX + 20], [@dataY - 10, @dataY + 20]];

  updateData: () =>
    @removeData();
    @loadData();

  removeData: () =>
    @dataSets.remove (dataSet) ->
      return dataSet.x < @dataX - 10 || dataSet.x2 > @dataX + 10 || dataSet.y < @dataY - 10 || dataSet.y2 > @dataY + 10;

  loadData: (callback) =>
    for x in [0, 10, -10]
      for y in [0, 10, -10]
        px = x + @dataX;
        py = y + @dataY;

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

  getVegetation: (rx, ry) =>
    field = @_getField(rx, ry)
    if field?
      return field['vegetation'];

  mapMovedTo: (ax, ay, fieldSize, callback) =>
    rx = Math.floor(-ax / fieldSize);
    ry = Math.floor(-ay / fieldSize);
    if @rx != rx || @ry != ry
      @setDataPosition(rx - @rx, ry - @ry);
      @updateData();
      callback(deltaX, deltaY);

  setDataPosition: (rx, ry) =>
    @rx = rx; # viewport x
    @ry = ry; # viewport y
    @dataX = Math.ceil(@rx / 10) * 10; # dataset start x
    @dataY = Math.ceil(@ry / 10) * 10; # dataset start y

  eachField: (startX, endX, startY, endY, callback) =>
    for y in [startY...endY]
      for x in [startX...endX]
        callback(@rx + x, @ry + y);

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
