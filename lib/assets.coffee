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

      "banana_1": "/images/banana-1@2x.png",
      "banana_2": "/images/banana-2@2x.png",
      "banana_3": "/images/banana-3@2x.png",

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
    @_getSprite("vegetation_#{type}");

  getFloraSprite: (type) =>
    @_getSprite(type);

  getFaunaSprite: (type) =>
    @_getSprite(type);

  returnSprite: (image, sprite) =>
    @pool.returnSprite(image, sprite);

  # private

  _getSprite: (type) =>
    image = @assets[type]
    if image?
      @pool.getSprite(image);
    else
      console.log("ERROR: unkown type: #{type}");
