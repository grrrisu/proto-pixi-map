class Game.Assets

  constructor: () ->
    # preload also the background images, when Pixi loads Texture.fromImage
    # it first looks in the cache before loading from the file system
    @vegetation = {
      "type_0": "/images/0_desert@2x.png",
      "type_1": "/images/1_grass@2x.png",
      "type_2": "/images/2_grass@2x.png",
      "type_3": "/images/3_grass@2x.png",
      "type_5": "/images/5_grass@2x.png",
      "type_8": "/images/8_forest@2x.png",
      "type_13": "/images/13_forest@2x.png"
    }
    images = Object.values(@vegetation);
    @pool = new Game.SpritePool(images);

  load: (callback) =>
    assetsToLoad = Object.values(@vegetation);
    loader = new PIXI.AssetLoader(assetsToLoad);
    loader.onComplete = callback;
    loader.load();

  getVegetationSprite: (type) =>
    image = @vegetation["type_#{type}"];
    if image?
      @pool.getSprite(image);
    else
      console.log("ERROR: unkown type: #{type}");

  returnSprite: (image, sprite) =>
    @pool.returnSprite(image, sprite);
