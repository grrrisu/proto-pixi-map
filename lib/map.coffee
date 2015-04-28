class Game.Map

  constructor: (stage, options) ->
    @layer = new PIXI.DisplayObjectContainer();
    @drag_handler = new Game.MapDragHandler(@layer, this);
    stage.addChild(@layer);
    @data   = new Game.MapData();

    @width = options['width'];
    @height = options['height'];
    @fieldSize = options['fieldSize'];

  create: () =>
    console.log('create map');
    @createFields();

  init: (callback) =>
    Game.main.apiCaller.get '/spec/fixtures/init_map.json', (data) =>
      data = JSON.parse(data);
      @data.rx = data.headquarter.x - Math.floor(@fieldWidth() / 2);
      @data.ry = data.headquarter.y - Math.floor(@fieldHeight() / 2);
      @ax = 0 - @width % @fieldSize;
      @ay = 0 - @height % @fieldSize;
      @data.setupData(callback);

  mapMovedTo: (ax, ay) =>
    @ax = ax;
    @ay = ay;
    rx = Math.floor(@ax / @fieldSize)
    ry = Math.floor(@ay / @fieldSize)
    @data.mapMovedTo(rx, ry);

  createFields: () =>
    for y in [0..@fieldHeight()]
      for x in [0..@fieldWidth()]
        vegetation = @data.getVegetation(x, y);
        #console.log(vegetation.type);
        sprite = Game.main.assets.getVegetationSprite(vegetation.type)
        sprite.position.x = @ax + x * (@fieldSize + 1); # +1 for border
        sprite.position.y = @ay + y * (@fieldSize + 1); # +1 for border
        #console.log(sprite.position);
        @layer.addChild(sprite);

  fieldWidth: () ->
    Math.ceil(@width / @fieldSize)

  fieldHeight: () ->
    Math.ceil(@height / @fieldSize)
