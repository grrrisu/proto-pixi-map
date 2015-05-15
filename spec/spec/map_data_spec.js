describe("MapData", function() {

  beforeAll(function() {
    data =
    `{
      "x": 25,
      "y": 50,
      "view":
      [
        [
          {
            "x": 25,
            "y": 50,
            "vegetation": {
              "type": 1,
              "size": 50
            }
          },
          {
            "x": 26,
            "y": 50,
            "vegetation": {
              "type": 2,
              "size": 100
            }
          }
        ],
        [
          {
            "x": 25,
            "y": 51,
            "vegetation": {
              "type": 3,
              "size": 250
            }
          },
          {
            "x": 26,
            "y": 51,
            "vegetation": {
              "type": 5,
              "size": 500
            }
          }
        ]
      ]
    }`;

    mapData = new Game.MapData();
    mapData.addDataSet(data);
  });

  it("should set dimensions", function() {
    dataSet = mapData.dataSets[0]
    expect(dataSet['x2']).toEqual(26);
    expect(dataSet['y2']).toEqual(51);
  });

  it("should get vegetation", function() {
    vegetation = mapData.getVegetation(25, 50);
    expect(vegetation.type).toEqual(1);
  });

});
