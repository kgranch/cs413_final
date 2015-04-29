import starling.core.Starling;
import starling.display.*;

class Tilemap extends Sprite
{

  public var map: Array<Image>;

  public function new(grid : Array<UInt>)
  {
    super();

    map = new Array<Image>();

    for(i in 0...grid.length){
        if (grid[i] == 1){
          var im = new Image(Game.assets.getTexture("wall"));
          im.y = i%100 * 64; im.x = Math.floor(i/100) * 64;
          map.push(im);
          addChild(im);
        }
      
    }
  }

  public function deleteMap()
  {
    for (i in 0...map.length){
      removeChild(map[i]);
      map[i] = null;
    }
    map = null;
  }
}