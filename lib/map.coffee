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
    @createFields(0, @fieldWidth, 0, @fieldHeight);

  createFields: (startX, endX, startY, endY) =>
    for y in [startY...endY]
      for x in [startX...endX]
        rx = @data.rx + x;
        ry = @data.ry + y;
        vegetation = @data.getVegetation(rx, ry);
        @createField(rx, ry, vegetation);

  createField: (rx, ry, vegetation) =>
    if vegetation?

      already_created = @fields.any (field) =>
        return field.rx == rx && field.ry == ry;

      unless already_created
        field = new Game.Field(rx, ry);
        @fields.unshift(field);
        @mapLayer.setVegetation(rx, ry, vegetation, @fieldSize, field);

  mapMovedTo: (ax, ay) =>
    @mapLayer.mapMovedTo(ax, ay);
    @data.mapMovedTo ax, ay, @fieldSize, (deltaX, deltaY) =>
      console.log("rx #{@data.rx} dx #{deltaX}");
      if deltaX > 0 # move to the right
        @createFields(@fieldWidth - deltaX, @fieldWidth, 0, @fieldHeight);
      else if deltaX < 0 # move to the left
        @createFields(0, Math.abs(deltaX), 0, @fieldHeight);
      if deltaY > 0 # move down
        @createFields(0, @fieldWidth, @fieldHeight - deltaY, @fieldHeight);
      else if deltaY < 0 # move up
        @createFields(0, @fieldWidth, 0, Math.abs(deltaY));

  center: () =>
    # move to headquarter position or init rx, ry for admin