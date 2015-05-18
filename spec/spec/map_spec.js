describe("Map", function() {

  beforeEach(function(){
    stage = new PIXI.Stage(0x454545);
    map   = new Game.Map(stage,
                {
                  width: 1040,
                  height: 520,
                  fieldSize: 55
                });
  });

  describe("position convertion", function() {

    it("should convert absolute position", function() {
      position = map.toRelativePosition(-43, -80);
      expect(position).toEqual([0, 1]);
    });

  });


});