class Game.Field

  constructor: (@rx, @ry) ->

  clear: (mapLayer) =>
    @removeFloraSprite() if @floraSprite?;
    @removeFaunaSprite() if @faunaSprite?;
    @removePawnSprite()  if @pawnSprite?;
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
    @remove_from_vegetation(@floraSprite);
    @floraSprite = null;

  setFaunaSprite: (sprite) =>
    @faunaSprite = sprite;

  removeFaunaSprite: () =>
    @remove_from_vegetation(@faunaSprite);
    @faunaSprite = null;

  setPawnSprite: (sprite) =>
    @pawnSprite = sprite;

  removePawnSprite: () =>
    @remove_from_vegetation(@pawnSprite);
    @pawnSprite = null;

  # private

  remove_from_vegetation: (sprite) =>
    @vegetationSprite.removeChild(sprite);
    @returnSprite(sprite);

  returnSprite: (sprite) =>
    image = sprite.texture.baseTexture.imageUrl;
    if image?
      Game.main.assets.returnSprite(sprite, image);
