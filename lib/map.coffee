class Game.Map

  constructor: (stage, options) ->
    @mapLayer     = new Game.MapLayer(stage);
    @drag_handler = new Game.MapDragHandler(@mapLayer.layer, this);
    @data         = new Game.MapData();
    @fields       = [];

    @fieldSize   = options['fieldSize'];
    @fieldWidth  = Math.ceil(options['width'] / @fieldSize) ;
    @fieldHeight = Math.ceil(options['height'] / @fieldSize);
    @mapLayer.setOutset(options['width'], options['height'], @fieldSize);

  init: (callback) =>
    @data.initMap @fieldWidth, @fieldHeight, () =>
      x = -@data.rx * @fieldSize + Math.ceil(@fieldWidth * @fieldSize / 2)
      y = -@data.ry * @fieldSize + Math.ceil(@fieldWidth * @fieldSize / 2)
      @mapLayer.mapMovedTo(x, y);
      callback();

  create: () =>
    @createFields(@fieldWidth, @fieldHeight);

  createFields: (rangeX, rangeY) =>
    for y in [0..rangeY]
      for x in [0..rangeX]
        vegetation = @data.getVegetation(x, y);
        field = new Game.Field(@data.rx + x, @data.ry + y);
        @fields.push(field);
        @mapLayer.setVegetation(x, y, vegetation, @fieldSize, field);

  mapMovedTo: (ax, ay) =>
    @mapLayer.mapMovedTo(ax, ay);
    @data.mapMovedTo ax, ay, @fieldSize, (deltaX, deltaY) =>
      console.log("rx #{@data.rx} dx #{deltaX}");
      # if deltaX != 0
      #   @createFields(deltaX, @fieldHeight);
      # else if deltaY != 0
      #   @createFields(@fieldWidth, deltaY);

  center: () =>
    # move to headquarter position or init rx, ry for admin