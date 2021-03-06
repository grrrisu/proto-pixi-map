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
      "base": "/images/caveman.png"
    }
    images = Object.values(@assets);
    @pool = new Game.SpritePool(images);
    @pawns = new Game.PawnPool();

  load: (callback) =>
    loader = PIXI.loader
    Object.each @assets, (name, image) =>
      loader.add(name, image);
    loader.load (loader, resources) ->
      callback();

  getVegetationSprite: (type) =>
    @getSprite("vegetation_#{type}");

  getFloraSprite: (type) =>
    @getSprite(type);

  getFaunaSprite: (type) =>
    @getSprite(type);

  getPawnSprite: (type, id) =>
    if id?
      pawn = @pawns.getPawn(id)
      return pawn if pawn?

    @getSprite(type);

  returnSprite: (sprite) =>
    if sprite.interactive == false
      image = sprite.texture.baseTexture.imageUrl;
      if image?
        @pool.returnSprite(image, sprite);

  # private

  getSprite: (type) =>
    image = @assets[type]
    if image?
      @pool.getSprite(image);
    else
      console.log("ERROR: unkown type: #{type}");
