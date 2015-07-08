class Game.ScaleController

  constructor: (@map) ->
    @scale = 1.0
    @bindEvents();

  bindEvents: () =>
    $('#zoom-in').on('click', @zoomIn);
    $('#zoom-out').on('click', @zoomOut);

  zoomOut: () =>
    @zoom(@scale - 0.1);

  zoomIn: () =>
    @zoom(@scale + 0.1);

  zoom: (scale) =>
    @scale = scale;
    @map.zoom(@scale);
