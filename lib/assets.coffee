class Game.Assets

  constructor: () ->
    # preload also the background images, when Pixi loads Texture.fromImage
    # it first looks in the cache before loading from the file system
    @assets = {
      "vegetation_0": "/images/0_desert@2x.png",
      "vegetation_1": "/images/1_grass@2x.png",
      "vegetation_2": "/images/2_grass@2x.png",
      "vegetation_3": "/images/3_grass@2x.png",
      "vegetation_5": "/images/5_grass@2x.png",
      "vegetation_8": "/images/8_forest@2x.png",
      "vegetation_13": "/images/13_forest@2x.png",

      "banana-1": "/images/banana-1.png",
      "banana-2": "/images/banana-2.png",
      "banana-3": "/images/banana-3.png",

      "rabbit": "/images/rabbit.png",
      "gazelle": "/images/gazelle.png",
      "mammoth": "/images/meat.png",
      "hyena": "/images/hyena.png",
      "leopard": "/images/leopard.png"
    }
    images = Object.values(@assets);
    @pool = new Game.SpritePool(images);

  load: (callback) =>
    assetsToLoad = Object.values(@assets);
    loader = new PIXI.AssetLoader(assetsToLoad);
    loader.onComplete = callback;
    loader.load();

  getVegetationSprite: (type) =>
    @_getSprite(@assets["vegetation_#{type}"]);

  getFloraSprite: (type) =>
    @_getSprite(@assets[type]);

  getFaunaSprite: (type) =>
    @getFaunaSprite(type);

  returnSprite: (image, sprite) =>
    @pool.returnSprite(image, sprite);

  # private

  _getSprite: (image) =>
    if image?
      @pool.getSprite(image);
    else
      console.log("ERROR: unkown type: #{type}");
