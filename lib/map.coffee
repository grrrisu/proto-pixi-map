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
    for y in [0..@fieldHeight()]
      for x in [0..@fieldWidth()]
        if @data['view'][y]?
          fieldData = @data['view'][y][x];
          if fieldData?
            type = fieldData['vegetation']['type']
            vegetation = Game.main.assets.createVegetationSprite(type)
            @layer.addChild(vegetation);

  fieldWidth: () ->
    Math.ceil(@width / @fieldSize) + 1

  fieldHeight: () ->
    Math.ceil(@height / @fieldSize) + 1
