class Game.Map

  constructor: (stage, options) ->
    @mapLayer         = new Game.MapLayer(stage);
    @drag_handler     = new Game.MapDragHandler(@mapLayer.layer, this);
    @scaleController  = new Game.ScaleController(this);
    @data             = new Game.MapData();
    @fields           = [];

    @fieldSize      = options['fieldSize'] + 1; # +1 border
    @viewportWidth  = options['width'];
    @viewportHeight = options['height'];
    @scale          = 1.0;
    @setDimensions();

  setDimensions: () =>
    @fieldWidth  = Math.floor(@viewportWidth / (@fieldSize * @scale)) + 2;
    @fieldHeight = Math.floor(@viewportHeight / (@fieldSize * @scale)) + 2;
    @data.setDataDimensions(@fieldWidth, @fieldHeight)

  init: (callback) =>
    @data.initMap (centerX, centerY) =>
      @setCenter(centerX, centerY);
      @moveToCenter(centerX, centerY);
      @data.setupData () =>
        callback();

  setCenter: (centerX, centerY) =>
    @centerX = centerX;
    @centerY = centerY;

  getCenter: () =>
    if @centerX? && @centerY
      return [@centerX, @centerY]
    else
      center = @toCenterPosition();
      @setCenter(center[0], center[1]);
      return [center[0], center[1]];

  clearCenter: () =>
    @centerX = null;
    @centerY = null;

  moveToCenter: (centerX, centerY) =>
    aposition = @centerToAbsolutePosition(centerX, centerY);
    rposition = @toRelativePosition(aposition[0], aposition[1]);
    @mapLayer.mapMovedTo(aposition[0], aposition[1]);
    @data.setDataPosition(rposition[0], rposition[1]);

  centerToAbsolutePosition: (centerX, centerY) =>
    ax = -(0.5 + centerX) * (@fieldSize * @scale) + @viewportWidth / 2;
    ay = -(0.5 + centerY) * (@fieldSize * @scale) + @viewportHeight / 2;
    return[ax, ay];

  toCenterPosition: () =>
    centerX = @data.rx + Math.floor(@fieldWidth / 2);
    centerY = @data.ry + Math.floor(@fieldHeight / 2);
    return [centerX, centerY];

  toRelativePosition: (ax, ay) =>
    rx = Math.floor(-ax / (@fieldSize * @scale));
    ry = Math.floor(-ay / (@fieldSize * @scale));
    return [rx, ry];

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
      @clearCenter();
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

  zoom: (newScale) =>
    center = @getCenter();
    @scale = newScale;
    @mapLayer.scale(newScale);
    @setDimensions();
    @moveToCenter(center[0], center[1]);
    @create();

  clearFields: () =>
    @fields.each (field) =>
      field.clear(@mapLayer);
    @fields = [];
