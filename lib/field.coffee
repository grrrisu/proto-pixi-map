class Game.Field

  constructor: (@rx, @ry) ->

  clear: () =>
    @removeVegetationSprite();

  setVegetationSprite: (sprite) =>
    @vegetationSprite = sprite;

  removeVegetationSprite: () =>
    @returnSprite(@vegetationSprite);
    @vegetationSprite = null;

  returnSprite: (sprite) =>
    image = sprite.texture.baseTexture.imageUrl;
    Game.main.assets.returnSprite(sprite, image);
