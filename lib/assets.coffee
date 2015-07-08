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

      "rabbit": "/images/rabbit@2x.png",
      "gazelle": "/images/gazelle@2x.png",
      "mammoth": "/images/meat@2x.png",
      "hyena": "/images/hyena@2x.png",
      "leopard": "/images/leopard@2x.png",

      "headquarter": "/images/Raratonga_Mask.gif",
      "pawn": "/images/caveman.png"
    }
    images = Object.values(@assets);
    @pool = new Game.SpritePool(images);

  load: (callback) =>
    assetsToLoad = Object.values(@assets);
    loader = new PIXI.loaders.Loader(assetsToLoad);
    loader.onComplete = callback;
    loader.load();

  getVegetationSprite: (type) =>
    @getSprite("vegetation_#{type}");

  getFloraSprite: (type) =>
    @getSprite(type);

  getFaunaSprite: (type) =>
    @getSprite(type);

  getPawnSprite: (type) =>
    @getSprite(type);

  returnSprite: (image, sprite) =>
    @pool.returnSprite(image, sprite);

  # private

  getSprite: (type) =>
    image = @assets[type]
    if image?
      @pool.getSprite(image);
    else
      console.log("ERROR: unkown type: #{type}");
