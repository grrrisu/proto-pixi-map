class Game.Map

  constructor: (stage, options) ->
    @mapLayer     = new Game.MapLayer(stage);
    @drag_handler = new Game.MapDragHandler(@mapLayer.layer, this);
    @data         = new Game.MapData();
    @fields       = [];

    @fieldSize = options['fieldSize'] + 1; # +1 border
    @viewportWidth  = options['width'];
    @viewportHeight = options['height'];
    @setDimensions(@fieldSize);
    @mapLayer.setOutset(options['width'], options['height'], @fieldSize);

  setDimensions: (fieldSize) =>
    @fieldWidth  = Math.floor(@viewportWidth  / fieldSize) + 2;
    @fieldHeight = Math.floor(@viewportHeight / fieldSize) + 2;

  init: (callback) =>
    @data.initMap @fieldWidth, @fieldHeight, () =>
      @moveLayer(@fieldSize);
      callback();

  moveLayer: (fieldSize) =>
    x = -(@data.rx + 1) * fieldSize + @mapLayer.outsetX; # +1 begin outside of viewport
    y = -(@data.ry + 1) * fieldSize + @mapLayer.outsetY; # +1 begin outside of viewport
    @mapLayer.mapMovedTo(x, y);

  create: () =>
    @createFields(0, @fieldWidth, 0, @fieldHeight);

  createFields: (startX, endX, startY, endY) =>
    @data.eachField startX, endX, startY, endY, (rx, ry) =>
      data = @data.getField(rx, ry);
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
    @mapLayer.scale(n);
    @setDimensions(@fieldSize * n);
    @moveLayer(@fieldSize * n);
    @create();

  clearFields: () =>
    @fields.each (field) =>
      field.clear(@mapLayer);
    @fields = [];

  toRelativePosition: (ax, ay) =>
    rx = Math.floor(-ax / @fieldSize);
    ry = Math.floor(-ay / @fieldSize);
    return [rx, ry];
