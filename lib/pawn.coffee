class Game.Pawn

  constructor: (data) ->
    @id = data.id;
    @x  = data.x;
    @y  = data.y;
    @type = data.type;
    @view_radius = data.view_radius;
    @sprite = @initSprite();


  initSprite: () =>
    @sprite = Game.main.assets.getPawnSprite(@type);
    @sprite.interactive = true;
    @sprite.buttonMode = true;
    @sprite.anchor.set(0.5);

    # setup events
    @sprite
      # events for drag start
      .on('mousedown', @onDragStart)
      .on('touchstart', @onDragStart)
      # events for drag end
      .on('mouseup', @onDragEnd)
      .on('mouseupoutside', @onDragEnd)
      .on('touchend', @onDragEnd)
      .on('touchendoutside', @onDragEnd)
      # events for drag move
      .on('mousemove', @onDragMove)
      .on('touchmove', @onDragMove);

    Game.main.assets.pawns.setPawn(@id, @sprite);


  onDragStart: (event) =>
    @dragging = true;
    @startPosition = {x: @sprite.position.x, y: @sprite.position.y};
    Game.main.stage.map.drag_handler.setDragable(false);
    Game.main.stage.map.lowlight_around(@x, @y, @view_radius);
    @sprite.alpha = 0.7;
    @sprite.scale.set(1.5);

  onDragMove: (event) =>
    if @dragging
      newPosition = event.data.getLocalPosition(@sprite.parent);
      fieldSize = Game.main.stage.map.fieldSize;
      dx = Math.abs(@startPosition.x - newPosition.x)
      dy = Math.abs(@startPosition.y - newPosition.y)
      restrictedPosition = Game.main.stage.map.restrictToRadius(dx, dy, @view_radius * fieldSize, fieldSize)
      if newPosition.x >= @startPosition.x
        @sprite.position.x = @startPosition.x + restrictedPosition.dx;
      else
        @sprite.position.x = @startPosition.x - restrictedPosition.dx;
      if newPosition.y >= @startPosition.y
        @sprite.position.y = @startPosition.y + restrictedPosition.dy;
      else
        @sprite.position.y = @startPosition.y - restrictedPosition.dy;

  onDragEnd: (event) =>
    Game.main.stage.map.drag_handler.setDragable(true);
    Game.main.stage.map.reset_lowlight();
    @sprite.alpha = 1.0;
    @sprite.scale.set(1);
    @dragging = false;
    newPosition = @snapToGrid(@sprite.position.x, @sprite.position.y);
    @sprite.position.set(newPosition.ax, newPosition.ay);
    @x = newPosition.rx;
    @y = newPosition.ry;

  snapToGrid: (ax, ay) =>
    fieldSize = Game.main.stage.map.fieldSize;
    rx = Math.round((ax - (0.5 * fieldSize)) / fieldSize);
    ry = Math.round((ay - (0.5 * fieldSize)) / fieldSize);
    ax = (rx + 0.5) * fieldSize;
    ay = (ry + 0.5) * fieldSize;
    return {ax: ax, ay: ay, rx: rx, ry: ry};
