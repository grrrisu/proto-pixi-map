class Game.MapDragHandler

  constructor: (layer, map) ->
    @layer = layer;
    @map = map;
    @layer.interactive = true; # let's receive events
    @dragging = false;
    @layer.mousedown      = @dragStart;
    @layer.touchstart     = @dragStart;
    @layer.mouseup        = @dragEnd;
    @layer.mouseupoutside = @dragEnd;
    @layer.touchend       = @dragEnd;
    @layer.mousemove      = @dragMove;
    @layer.touchmove      = @dragMove;

  dragStart: (event) =>
    @dragging = true
    position = event.data.getLocalPosition(@layer.parent); # get position relative to stage
    @dragStartX = position.x - @layer.position.x
    @dragStartY = position.y - @layer.position.y

  dragEnd: (event) =>
    @dragging = false;

  dragMove: (event) =>
    if @dragging
      position = event.data.getLocalPosition(@layer.parent); # get position relative to stage
      x = position.x - @dragStartX;
      y = position.y - @dragStartY;
      @map.mapMovedTo(x, y);
