class Game.Main

  constructor: (element_id) ->
    @stage     = new Game.Stage(element_id);
    @apiCaller = new Game.ApiCaller();
    @assets    = new Game.Assets();

  run: () =>
    @assets.load(@assetsLoaded);
    @map.data.loadInitialMapData(@dataLoaded);

  assetsLoaded: () =>
    if @dataLoaded == true
      @create();
    else
      @assetsLoaded = true
      console.log("assets loaded first");
    requestAnimFrame(@stage.update);

  dataLoaded: (data) =>
    if @assetsLoaded == true
      @create();
    else
      @dataLoaded = true
      console.log("data loaded first");

  create: () =>
    console.log('create main');
    @stage.create();
