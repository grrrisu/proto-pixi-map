class Game.Main

  constructor: (element_id) ->
    @element   = document.getElementById(element_id);
    @resolution = window.devicePixelRatio;
    @stage     = new PIXI.Stage(0x454545);
    @renderer  = PIXI.autoDetectRenderer(
      @element.width,
      @element.height,
      view: @element,
      resolution: @resolution
    );
    #document.body.appendChild(@renderer.view);

    @apiCaller = new Game.ApiCaller();
    @assets    = new Game.Assets();
    @map       = new Game.Map(@stage);

    @assets.load(@assetsLoaded)
    @loadInitialMapData();

  loadInitialMapData: () =>
    @apiCaller.get('/spec/fixtures/map.json', @dataLoaded);

  assetsLoaded: () =>
    if @dataLoaded == true
      @create();
    else
      @assetsLoaded = true
      console.log("assets loaded first");
    requestAnimFrame(@update.bind(this));

  dataLoaded: (data) =>
    data = JSON.parse(data);
    @map.setData(data);
    if @assetsLoaded == true
      @create();
    else
      @dataLoaded = true
      console.log("data loaded first");

  update: () ->
    #@map.layer.position.x += 2;
    @renderer.render(@stage);
    # called 60 times per sec / 60 FPS (FramePerSeconds)
    requestAnimFrame(@update.bind(this));

  create: () =>
    console.log('create main');
    @map.create
      width: @element.width / @resolution
      height: @element.height / @resolution
      fieldSize: 55
      ax: 25
      ay: 50
