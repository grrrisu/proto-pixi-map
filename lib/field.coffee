class Field

  constructor: (@rx, @ry) ->

  setVegetationSprite: (sprite) =>
    @vegetationSprite = sprite;

  removeVegetationSprite: () =>
    sprite = @vegetationSprite;
    @vegetationSprite = null;
    return sprite;
