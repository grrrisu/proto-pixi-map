describe("Main", function() {

  beforeAll(function() {
    map = document.createElement('canvas');
    map.setAttribute('id', 'map');
    map.setAttribute('width', '600')
    map.setAttribute('height', '300')
    map.setAttribute('style', 'width: 600px; height: 300px;')
    document.body.appendChild(map);

    main = new Game.Main('map');
  });

  it("should create stage", function() {
    expect(main.stage).not.toBeUndefined();
  });

  it("should create renderer", function() {
    expect(main.renderer.width).toEqual(600);
    expect(main.renderer.height).toEqual(300);
  });

});
