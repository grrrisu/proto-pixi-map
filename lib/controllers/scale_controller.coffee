class Game.ScaleController

  constructor: (@map) ->
    @scale = 1.0
    @bindEvents();

  bindEvents: () =>
    $('#zoom-in').on('click', @zoomIn);
    $('#zoom-out').on('click', @zoomOut);

  zoomOut: () =>
    @zoom(@scale - 0.05);

  zoomIn: () =>
    @zoom(@scale + 0.05);

  zoom: (scale) =>
    @scale = scale;
    @map.scale(@scale);
