class Game.Main

  constructor: (element_id) ->
    @element   = document.getElementById(element_id);
    console.log(@element);
    @stage     = new PIXI.Stage(0x66FF99);
    @renderer  = PIXI.autoDetectRenderer(
      @element.width,
      @element.height,
      {view: @element}
    );
    @loadAssets();
    @loadInitialMapData();

  loadAssets: () =>
    # preload also the background images, when Pixi loads Texture.fromImage
    # it first looks in the cache before loading from the file system
    assetsToLoad = [
      "images/0_desert@2x.png"
    ];

    loader = new PIXI.AssetLoader(assetsToLoad);
    loader.onComplete = @assetsLoaded;
    loader.load();

  @loadInitialMapData: () =>


  assetsLoaded: () =>
    @create();
    requestAnimFrame(@update.bind(this));

  update: () ->
    @renderer.render(@stage);

    # called 60 times per sec / 60 FPS (FramePerSeconds)
    requestAnimFrame(@update.bind(this));

  create: () =>
    console.log('create')
