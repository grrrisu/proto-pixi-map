class Game.Headquarter extends Game.Pawn

  constructor: (data) ->
    super(data.headquarter);
    @pawns = @createPawns(data.headquarter.pawns);

  createPawns: (data) =>
    data.map (pawn_data) =>
      new Game.Pawn(pawn_data);
