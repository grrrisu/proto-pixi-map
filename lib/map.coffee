class Game.Map

  constructor: (stage, options) ->
    @mapLayer     = new Game.MapLayer(stage);
    @drag_handler = new Game.MapDragHandler(@mapLayer.layer, this);
    @data         = new Game.MapData();
    @fields       = [];

    @origFieldSize   = @fieldSize = options['fieldSize'] + 1; # +1 border
    @viewportWidth  = options['width'];
    @viewportHeight = options['height'];
    @setDimensions();
    @mapLayer.setOutset(options['width'], options['height'], @fieldSize);

  setDimensions: () =>
    @fieldWidth  = Math.floor(@viewportWidth  / @fieldSize) + 2;
    @fieldHeight = Math.floor(@viewportHeight / @fieldSize) + 2;

  init: (callback) =>
    @data.initMap @fieldWidth, @fieldHeight, () =>
      @moveLayer();
      callback();

  moveLayer: () =>
    x = -(@data.rx + 1) * @fieldSize + @mapLayer.outsetX; # +1 begin outside of viewport
    y = -(@data.ry + 1) * @fieldSize + @mapLayer.outsetY; # +1 begin outside of viewport
    @mapLayer.mapMovedTo(x, y);

  create: () =>
    @createFields(0, @fieldWidth, 0, @fieldHeight);

  createFields: (startX, endX, startY, endY) =>
    console.log(endX);
    @data.eachField startX, endX, startY, endY, (rx, ry) =>
      data = @data.getField(rx, ry);
      console.log("rx #{rx} ry #{ry} #{data}");
      @createField(rx, ry, data) if data?;

  removeFields: (startX, endX, startY, endY) =>
    @data.eachField startX, endX, startY, endY, (rx, ry) =>
      @fields.remove (field) =>
        if field.rx == rx && field.ry == ry
          field.clear(@mapLayer);
          return true;

  createField: (rx, ry, data) =>
    already_created = @fields.any (field) =>
      return field.rx == rx && field.ry == ry;

    unless already_created
      field = @mapLayer.setField(rx, ry, data, @fieldSize);
      @fields.unshift(field);

  mapMovedTo: (ax, ay) =>
    @mapLayer.mapMovedTo(ax, ay);
    position = @toRelativePosition(ax, ay);
    @data.mapMovedTo position[0], position[1], (deltaX, deltaY) =>
      if deltaX > 0 # move to the right
        @createFields(@fieldWidth - deltaX, @fieldWidth, 0, @fieldHeight);
        @removeFields(0 - deltaX, 0, 0, @fieldHeight);
      else if deltaX < 0 # move to the left
        @createFields(0, Math.abs(deltaX), 0, @fieldHeight);
        @removeFields(@fieldWidth, @fieldWidth - deltaX, 0, @fieldHeight);
      if deltaY > 0 # move down
        @createFields(0, @fieldWidth, @fieldHeight - deltaY, @fieldHeight);
        @removeFields(0, @fieldWidth, 0 - deltaY, 0);
      else if deltaY < 0 # move up
        @createFields(0, @fieldWidth, 0, Math.abs(deltaY));
        @removeFields(0, @fieldWidth, @fieldHeight, @fieldHeight - deltaY);

  center: () =>
    # move to headquarter position or init rx, ry for admin

  scale: (n) =>
    @fieldSize   = @origFieldSize * n;
    @setDimensions();
    @mapLayer.layer.scale.x = n;
    @mapLayer.layer.scale.y = n;
    @moveLayer();
    @fields.each (field) =>
      field.clear;
    @create();


  toRelativePosition: (ax, ay) =>
    rx = Math.floor(-ax / @fieldSize);
    ry = Math.floor(-ay / @fieldSize);
    return [rx, ry];
