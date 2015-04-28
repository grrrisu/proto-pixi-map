class Game.Stage

  constructor: (element_id) ->
    @resolution = window.devicePixelRatio;
    @element   = document.getElementById(element_id);
    @stage     = new PIXI.Stage(0x454545);
    @renderer  = PIXI.autoDetectRenderer(
      @element.width,
      @element.height,
      view: @element,
      resolution: window.devicePixelRatio
    );
    @map       = new Game.Map @stage,
                  width: @element.width / @resolution
                  height: @element.height / @resolution
                  fieldSize: 55

  update: () =>
    @renderer.render(@stage);
    # called 60 times per sec / 60 FPS (FramePerSeconds)
    requestAnimFrame(@update);

  create: () =>
    @map.create()
