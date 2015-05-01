class Game.MapLayer

  constructor: (stage) ->
    @layer = new PIXI.DisplayObjectContainer();
    stage.addChild(@layer);
    @ax = 0;
    @ay = 0;

  setOutset: (width, height, fieldSize) =>
    @outsetX = 0 - (width % fieldSize / 2).round();
    @outsetY = 0 - (height % fieldSize / 2).round();

  setVegetation: (x, y, vegetation, fieldSize, field) =>
    sprite = Game.main.assets.getVegetationSprite(vegetation.type)
    sprite.position.x = -@ax + @outsetX + x * (fieldSize + 1); # +1 for border
    sprite.position.y = -@ay + @outsetY + y * (fieldSize + 1); # +1 for border
    field.setVegetationSprite(sprite);
    @layer.addChild(sprite);

  mapMovedTo: (ax, ay) =>
    @ax = ax;
    @ay = ay;
    @layer.position.x = ax;
    @layer.position.y = ay;
