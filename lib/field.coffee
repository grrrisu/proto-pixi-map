class Game.Field

  constructor: (@rx, @ry) ->

  clear: (mapLayer) =>
    @removeFloraSprite() if @floraSprite?;
    @removeFaunaSprite() if @faunaSprite?;
    @removeVegetationSprite(mapLayer);

  setVegetationSprite: (sprite) =>
    @vegetationSprite = sprite;

  removeVegetationSprite: (mapLayer) =>
    mapLayer.layer.removeChild(@vegetationSprite);
    @returnSprite(@vegetationSprite);
    @vegetationSprite = null;

  setFloraSprite: (sprite) =>
    @floraSprite = sprite;

  removeFloraSprite: () =>
    @vegetationSprite.removeChild(@floraSprite);
    @returnSprite(@floraSprite);
    @floraSprite = null;

  setFaunaSprite: (sprite) =>
    @faunaSprite = sprite;

  removeFaunaSprite: () =>
    @vegetationSprite.removeChild(@faunaSprite);
    @returnSprite(@faunaSprite);
    @faunaSprite = null;

  returnSprite: (sprite) =>
    image = sprite.texture.baseTexture.imageUrl;
    Game.main.assets.returnSprite(sprite, image);
