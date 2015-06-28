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
    @scale          = 1.0
    @setDimensions(@fieldSize);

  setDimensions: (fieldSize) =>
    @fieldWidth  = Math.floor(@viewportWidth * @scale / fieldSize) + 2;
    @fieldHeight = Math.floor(@viewportHeight * @scale / fieldSize) + 2;
    @data.setDataDimensions(@fieldWidth, @fieldHeight)

  init: (callback) =>
    @data.initMap (centerX, centerY) =>
      console.log('after data init')

      aposition = @centerToAbsolutePosition(centerX, centerY);
      console.log(aposition);
      rposition = @toRelativePosition(aposition[0], aposition[1]);
      @mapLayer.mapMovedTo(aposition[0], aposition[1]);
      @data.setDataPosition(rposition[0], rposition[1]);

      @data.setupData () =>
        callback();

  centerToAbsolutePosition: (centerX, centerY) =>
    ax = -(0.5 + centerX) * @fieldSize * @scale + @viewportWidth / 2;
    ay = -(0.5 + centerY) * @fieldSize * @scale + @viewportHeight / 2;
    return[ax, ay];

  # centerDataPosition: (oldWidth, oldHeight) =>
  #   cx = @data.rx + Math.floor(oldWidth / 2)
  #   cy = @data.ry + Math.floor(oldHeight / 2)
  #   @data.centerPosition(cx, cy, @fieldWidth, @fieldHeight);

  create: () =>
    console.log('create')
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

  scale: (newScale) =>
    oldWidth = @fieldWidth;
    oldHeight = @fieldHeight;
    @mapLayer.scale(newScale);
    @setDimensions(@fieldSize * newScale);
    @move(@fieldSize * newScale, oldWidth, oldHeight);
    @create();

  clearFields: () =>
    @fields.each (field) =>
      field.clear(@mapLayer);
    @fields = [];

  toRelativePosition: (ax, ay) =>
    rx = Math.floor(-ax / @fieldSize);
    ry = Math.floor(-ay / @fieldSize);
    return [rx, ry];
