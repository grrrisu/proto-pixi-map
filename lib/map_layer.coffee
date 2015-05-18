class Game.MapLayer

  constructor: (stage) ->
    @layer = new PIXI.DisplayObjectContainer();
    stage.addChild(@layer);

  setOutset: (width, height, fieldSize) =>
    @outsetX = (width % fieldSize / 2).round();
    @outsetY = (height % fieldSize / 2).round();

  setField: (x, y, data, fieldSize) =>
    field = new Game.Field(x, y);
    vegetationSprite = @setVegetation(x, y, data.vegetation, fieldSize, field);
    @setFlora(data.flora, vegetationSprite, field) if data.flora?;
    return field;

  setVegetation: (x, y, vegetation, fieldSize, field) =>
    sprite = Game.main.assets.getVegetationSprite(vegetation.type)
    sprite.position.x = x * (fieldSize);
    sprite.position.y = y * (fieldSize);
    field.setVegetationSprite(sprite);
    @layer.addChild(sprite);

  setFlora: (data, parent, field) =>
    sprite = Game.main.assets.getFloraSprite(data.type);
    field.setFloraSprite(sprite);
    parent.addChild(sprite);

  mapMovedTo: (ax, ay) =>
    @ax = ax;
    @ay = ay;
    @layer.position.x = ax;
    @layer.position.y = ay;
