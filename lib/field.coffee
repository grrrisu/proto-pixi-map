class Game.Field

  constructor: (@rx, @ry) ->

  clear: () =>
    @removeVegetationSprite();
    @removeFloraSprite();

  setVegetationSprite: (sprite) =>
    @vegetationSprite = sprite;

  removeVegetationSprite: () =>
    @returnSprite(@vegetationSprite);
    @vegetationSprite = null;

  setFloraSprite: (sprite) =>
    @floraSprite = sprite;

  removeFloraSprite: () =>
    @returnSprite(@floraSprite) if @floraSprite?;
    @floraSprite = null;

  returnSprite: (sprite) =>
    image = sprite.texture.baseTexture.imageUrl;
    Game.main.assets.returnSprite(sprite, image);
