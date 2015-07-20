class Game.Pawn

  constructor: (data) ->
    @id = data.id;
    @x  = data.x;
    @y  = data.y;
    @type = data.type;
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
    Game.main.stage.map.drag_handler.setDragable(false);
    @sprite.alpha = 0.7;
    @sprite.scale.set(1.5);
    @dragging = true;

  onDragMove: (event) =>
    if @dragging
      newPosition = event.data.getLocalPosition(@sprite.parent);
      @sprite.position.x = newPosition.x;
      @sprite.position.y = newPosition.y;

  onDragEnd: (event) =>
    Game.main.stage.map.drag_handler.setDragable(true);
    @sprite.alpha = 1.0;
    @sprite.scale.set(1);
    @dragging = false;
    newPosition = @snapToGrid(@sprite.position.x, @sprite.position.y);
    @sprite.position.set(newPosition[0], newPosition[1]);

  snapToGrid: (ax, ay) =>
    fieldSize = Game.main.stage.map.fieldSize;
    rx = Math.round((ax - (0.5 * fieldSize)) / fieldSize);
    ry = Math.round((ay - (0.5 * fieldSize)) / fieldSize);
    ax = (rx + 0.5) * fieldSize;
    ay = (ry + 0.5) * fieldSize;
    return [ax, ay];
