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

  it("should set position", function() {
    mapData.setDataPosition(33, 47);
    expect(mapData.rx).toEqual(33);
    expect(mapData.ry).toEqual(47);
    expect(mapData.dataX).toEqual(30);
    expect(mapData.dataY).toEqual(50);
  });

  it("should load data", function() {
    callback = function() {};
    spyOn(mapData, "isDataSetLoaded").and.returnValue(true);

    mapData.loadData(callback);
    expect(mapData.isDataSetLoaded).toHaveBeenCalled();
    expect(mapData.isDataSetLoaded.calls.count()).toEqual(9);

    expect(mapData.isDataSetLoaded.calls.argsFor(0)).toEqual([30, 50]);
    expect(mapData.isDataSetLoaded.calls.argsFor(1)).toEqual([30, 60]);
    expect(mapData.isDataSetLoaded.calls.argsFor(2)).toEqual([30, 40]);
    expect(mapData.isDataSetLoaded.calls.argsFor(3)).toEqual([40, 50]);
    expect(mapData.isDataSetLoaded.calls.argsFor(4)).toEqual([40, 60]);
    expect(mapData.isDataSetLoaded.calls.argsFor(5)).toEqual([40, 40]);
    expect(mapData.isDataSetLoaded.calls.argsFor(6)).toEqual([20, 50]);
    expect(mapData.isDataSetLoaded.calls.argsFor(7)).toEqual([20, 60]);
    expect(mapData.isDataSetLoaded.calls.argsFor(8)).toEqual([20, 40]);
  });

  it("should update data when moving map", function(){
    callback = function() {};
    mapData.mapMovedTo(43, 80, 15, callback);
  });

});
