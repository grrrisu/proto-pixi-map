class Game.Map

  constructor: (stage) ->
    @layer = new PIXI.DisplayObjectContainer();
    @data  = new Game.MapData();
    stage.addChild(@layer);

  create: (options) =>
    @width = options['width']
    @height = options['height']
    @fieldSize = options['fieldSize']
    @ax = options['ax']
    @ay = options['ay']
    @createFields();

  setData: (data) =>
    @data.addDataSet(data);

  createFields: () =>
    for y in [0..@fieldHeight()]
      for x in [0..@fieldWidth()]
        vegetation = @data.getVegetation(@ax + x,@ay + y);
        sprite = Game.main.assets.createVegetationSprite(vegetation.type)
        sprite.position.x = x * (@fieldSize + 1);
        sprite.position.y = y * (@fieldSize + 1);
        @layer.addChild(sprite);

  fieldWidth: () ->
    Math.ceil(@width / @fieldSize) + 1

  fieldHeight: () ->
    Math.ceil(@height / @fieldSize) + 1
