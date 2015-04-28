class Game.MapLayer

  constructor: (stage) ->
    @layer = new PIXI.DisplayObjectContainer();
    stage.addChild(@layer);

  setOutset: (width, height, fieldSize) =>
    @outsetX = 0 - width % fieldSize;
    @outsetY = 0 - height % fieldSize;

  setVegetation: (x, y, vegetation, fieldSize) =>
    sprite = Game.main.assets.getVegetationSprite(vegetation.type)
    sprite.position.x = @outsetX + x * (fieldSize + 1); # +1 for border
    sprite.position.y = @outsetY + y * (fieldSize + 1); # +1 for border
    @layer.addChild(sprite);

  mapMovedTo: (ax, ay) =>
    @layer.position.x = ax
    @layer.position.y = ay
