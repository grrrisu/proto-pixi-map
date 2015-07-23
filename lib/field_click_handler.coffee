class Game.FieldClickHandler

  constructor: (layer, listeners, map) ->
    @layer = layer;
    @map = map;
    listeners.each (layer) =>
      layer.interactive = true;
      layer.on('mousedown', @onClick);
      layer.on('touchstart', @onClick);

  onClick: (event) =>
    position = event.data.getLocalPosition(@layer.parent);
    rposition = @toRelativePosition(position.x, position.y);
    field = @map.getFieldAt(rposition.rx, rposition.ry);
    if field == @prevField
      @toggleBorder();
    else
      @moveBorder(field);
    @prevField = field

  toRelativePosition: (ax, ay) =>
    fieldSize = Game.main.stage.map.fieldSize;
    rx = Math.floor(ax / fieldSize);
    ry = Math.floor(ay / fieldSize);
    return {rx: rx, ry: ry};

  drawBorder: () =>
    @graphics = new PIXI.Graphics();
    fieldSize = @map.fieldSize;
    @graphics.lineStyle(1, 0xAAAAAA, 1);
    @graphics.drawRect(0, 0, fieldSize, fieldSize);
    @graphics.endFill();
    @hideBorder();
    return @graphics;

  moveBorder: (field) =>
    fieldSize = @map.fieldSize;
    @graphics.position.x = field.rx * fieldSize - 1
    @graphics.position.y = field.ry * fieldSize - 1
    @showBorder();

  toggleBorder: () =>
    @graphics.visible = !@graphics.visible;

  hideBorder: () =>
    @graphics.visible = false;

  showBorder: () =>
    @graphics.visible = true;
