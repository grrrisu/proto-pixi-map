class Game.Map

  constructor: (stage, options) ->
    @mapLayer     = new Game.MapLayer(stage);
    @drag_handler = new Game.MapDragHandler(@mapLayer.layer, this);
    @data         = new Game.MapData();
    @fields       = [];

    @fieldSize   = options['fieldSize'] + 1; # +1 border
    @fieldWidth  = Math.floor(options['width'] / @fieldSize) + 2;
    @fieldHeight = Math.floor(options['height'] / @fieldSize) + 2;
    @mapLayer.setOutset(options['width'], options['height'], @fieldSize);

  init: (callback) =>
    @data.initMap @fieldWidth, @fieldHeight, () =>
      x = -(@data.rx + 1) * @fieldSize + @mapLayer.outsetX; # +1 begin outside of viewport
      y = -(@data.ry + 1) * @fieldSize + @mapLayer.outsetY; # +1 begin outside of viewport
      @mapLayer.mapMovedTo(x, y);
      callback();

  create: () =>
    console.log("x #{@data.rx} y #{@data.ry}");
    @createFields(@fieldWidth, @fieldHeight);

  createFields: (rangeX, rangeY) =>
    for y in [0...rangeY]
      for x in [0...rangeX]
        rx = @data.rx + x;
        ry = @data.ry + y;
        vegetation = @data.getVegetation(rx, ry);
        field = new Game.Field(rx, ry);
        @fields.push(field);
        @mapLayer.setVegetation(rx, ry, vegetation, @fieldSize, field);

  mapMovedTo: (ax, ay) =>
    @mapLayer.mapMovedTo(ax, ay);
    @data.mapMovedTo ax, ay, @fieldSize, (deltaX, deltaY) =>
      console.log("rx #{@data.rx} dx #{deltaX}");
      if deltaX != 0
        @createFields(deltaX, @fieldHeight);
      else if deltaY != 0
        @createFields(@fieldWidth, deltaY);

  center: () =>
    # move to headquarter position or init rx, ry for admin