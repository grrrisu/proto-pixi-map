class Game.MapLayer

  constructor: (stage) ->
    @layer = new PIXI.Container();
    stage.addChild(@layer);

  setFieldSize: (fieldSize) =>
    @fieldSize = fieldSize;

  setField: (x, y, data) =>
    field = new Game.Field(x, y);
    vegetationSprite = @setVegetation(x, y, data.vegetation, field);
    @setFlora(data.flora, vegetationSprite, field) if data.flora?;
    @setFauna(data.fauna, vegetationSprite, field) if data.fauna?;
    @setPawn(data.pawn, vegetationSprite, field) if data.pawn?;
    return field;

  setVegetation: (x, y, vegetation, field) =>
    sprite = Game.main.assets.getVegetationSprite(vegetation.type)
    sprite.position.x = x * (@fieldSize);
    sprite.position.y = y * (@fieldSize);
    field.setVegetationSprite(sprite);
    @layer.addChild(sprite);

  setFlora: (data, parent, field) =>
    sprite = Game.main.assets.getFloraSprite(data.type);
    field.setFloraSprite(sprite);
    @centerSprite(sprite);
    parent.addChild(sprite);

  setFauna: (data, parent, field) =>
    sprite = Game.main.assets.getFaunaSprite(data.type);
    field.setFaunaSprite(sprite);
    @centerSprite(sprite);
    parent.addChild(sprite);

  setPawn: (data, parent, field) =>
    sprite = Game.main.assets.getPawnSprite(data.type, data.id);
    field.setPawnSprite(sprite);
    @centerSprite(sprite);
    parent.addChild(sprite);

  centerSprite: (sprite) =>
    sprite.position.x = (@fieldSize - sprite.width ) / 2;
    sprite.position.y = (@fieldSize - sprite.height ) / 2;

  mapMovedTo: (ax, ay) =>
    @ax = ax;
    @ay = ay;
    @layer.position.x = ax;
    @layer.position.y = ay;

  getPosition: () =>
    @layer.position;

  scale: (n) =>
    @layer.scale.x = n;
    @layer.scale.y = n;
