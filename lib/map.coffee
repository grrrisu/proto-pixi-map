class Game.Map

  constructor: (stage) ->
    @layer = new PIXI.DisplayObjectContainer();
    stage.addChild(@layer);

  create: (options) =>
    @width = options['width']
    @height = options['height']
    @fieldSize = options['fieldSize']
    @ax = options['ax']
    @ay = options['ay']
    @createFields();

  setData: (data) =>
    @data = data;

  createFields: () =>
    for x in [0..@fieldWidth()]
      for y in [0..@fieldHeight()]
        texture = PIXI.Texture.fromImage("images/0_desert@2x.png");
        vegetation = new PIXI.Sprite(texture); # , 110, 110
        vegetation.position.x = x * @fieldSize;
        vegetation.position.y = y * @fieldSize;
        #vegetation.tilePosition.x = 0;
        #vegetation.tilePosition.y = 0;
        @layer.addChild(vegetation);

  fieldWidth: () ->
    Math.ceil(@width / @fieldSize) + 1

  fieldHeight: () ->
    Math.ceil(@height / @fieldSize) + 1
