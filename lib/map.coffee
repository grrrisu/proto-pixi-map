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
        fieldData = @data['view'][y][x];
        image = @vegetationTexture(fieldData['vegetation']['type']);
        texture = PIXI.Texture.fromImage("images/#{image}");
        vegetation = new PIXI.Sprite(texture);
        vegetation.position.x = x * @fieldSize;
        vegetation.position.y = y * @fieldSize;
        @layer.addChild(vegetation);

  vegetationTexture: (vegetationType) =>
    switch vegetationType
      when 0 then "0_desert@2x.png"
      when 1 then "1_grass@2x.png"
      when 2 then "2_grass@2x.png"
      when 3 then "3_grass@2x.png"
      when 5 then "5_grass@2x.png"
      when 8 then "8_forest@2x.png"
      when 13 then "13_forest@2x.png"
      else console.log("ERROR: unkown type: #{vegetationType}")

  fieldWidth: () ->
    Math.ceil(@width / @fieldSize) + 1

  fieldHeight: () ->
    Math.ceil(@height / @fieldSize) + 1
