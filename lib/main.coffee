class Game.Main

  constructor: (element_id) ->
    @stage     = new Game.Stage(element_id);
    @apiCaller = new Game.ApiCaller();
    @assets    = new Game.Assets();

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
    requestAnimFrame(@stage.update);

  dataLoaded: (data) =>
    data = JSON.parse(data);
    @stage.map.setData(data);
    if @assetsLoaded == true
      @create();
    else
      @dataLoaded = true
      console.log("data loaded first");

  create: () =>
    console.log('create main');
    @stage.create();
