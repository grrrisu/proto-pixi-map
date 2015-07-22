class Game.FieldClickHandler

  constructor: (layer, map) ->
    @layer = layer;
    @map = map;
    @layer.interactive = true;
    @layer.on('mousedown', @onClick);
    @layer.on('touchstart', @onClick);

  onClick: (event) =>
    position = event.data.getLocalPosition(@layer.parent);
    rposition = @toRelativePosition(position.x, position.y);
    console.log(rposition);
    field = @map.getFieldAt(rposition.rx, rposition.ry);
    console.log(field);
    field.drawBorder() if field?

  toRelativePosition: (ax, ay) =>
    fieldSize = Game.main.stage.map.fieldSize;
    rx = Math.floor(ax / fieldSize);
    ry = Math.floor(ay / fieldSize);
    return {rx: rx, ry: ry};
