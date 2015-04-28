class Game.Map

  constructor: (stage, options) ->
    @mapLayer     = new Game.MapLayer(stage);
    @drag_handler = new Game.MapDragHandler(@mapLayer.layer, this);
    @data         = new Game.MapData();

    @fieldSize   = options['fieldSize'];
    @fieldWidth  = Math.ceil(options['width'] / @fieldSize) ;
    @fieldHeight = Math.ceil(options['height'] / @fieldSize);
    @mapLayer.setOutset(options['width'], options['height'], @fieldSize);

  init: (callback) =>
    @data.initMap(@fieldWidth, @fieldHeight, callback);

  create: () =>
    @createFields();

  createFields: () =>
    for y in [0..@fieldHeight]
      for x in [0..@fieldWidth]
        vegetation = @data.getVegetation(x, y);
        @mapLayer.setVegetation(x, y, vegetation, @fieldSize);

  mapMovedTo: (ax, ay) =>
    @mapLayer.mapMovedTo(ax, ay);
    rx = Math.floor(ax / @fieldSize)
    ry = Math.floor(ay / @fieldSize)
    @data.mapMovedTo(rx, ry);

  center: () =>
    # move to headquarter position or init rx, ry for admin