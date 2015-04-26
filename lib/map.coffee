class Game.Map

  constructor: (stage) ->
    @layer = new PIXI.DisplayObjectContainer();
    @drag_handler = new Game.MapDragHandler(@layer, this);
    @data  = new Game.MapData();
    stage.addChild(@layer);

  create: (options) =>
    @width = options['width'];
    @height = options['height'];
    @fieldSize = options['fieldSize'];
    @setPosition(options['ax'], options['ay']);
    @createFields();

  mapMovedTo: (ax, ay) =>
    @setPosition(ax, ay);
    @data.mapMovedBy(@rx, @ry);

  setPosition: (ax, ay) =>
    @ax = ax;
    @ay = ay;
    @rx = Math.floor(@ax / @fieldSize)
    @ry = Math.floor(@ay / @fieldSize)

  createFields: () =>
    for y in [0..@fieldHeight()]
      for x in [0..@fieldWidth()]
        vegetation = @data.getVegetation(@rx + x, @ry + y);
        sprite = Game.main.assets.getVegetationSprite(vegetation.type)
        sprite.position.x = x * (@fieldSize + 1);
        sprite.position.y = y * (@fieldSize + 1);
        @layer.addChild(sprite);

  fieldWidth: () ->
    Math.ceil(@width / @fieldSize) + 1

  fieldHeight: () ->
    Math.ceil(@height / @fieldSize) + 1
