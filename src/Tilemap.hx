import starling.core.Starling;
import starling.display.*;

import Character;

class Tilemap extends Sprite
{

  public var walls: Array<Image>;
  public var goodBotList:List<Character> = new List<Character>();
  public var badBotList:List<Character> = new List<Character>();

  public function new(grid : Array<UInt>, driver:GameDriver)
  {
    super();

    walls = new Array<Image>();

    for(i in 0...grid.length){
        if (grid[i] == 1){
          //spawn a wall tile
          var im = new Image(Game.assets.getTexture("wall"));
          im.alignPivot();
          im.y = i%100 * 64; 
          im.x = Math.floor(i/100) * 64;
          walls.push(im);
          addChild(im);
        }else if (grid[i] == 2){
          //spawn a bad bot
          var badBot = new Character(2, Game.assets.getTextures("bad_botA"), driver);
          badBot.alignPivot();
          badBot.y = i%100 * 64; 
          badBot.x = Math.floor(i/100) * 64;
          badBotList.add(badBot);
          addChild(badBot);
        }else if (grid[i] == 3){
          //spawn a good bot
          var goodBot = new Character(3, Game.assets.getTextures("good_botA"), driver);
          goodBot.alignPivot();
          goodBot.y = i%100 * 64; 
          goodBot.x = Math.floor(i/100) * 64;
          goodBotList.add(goodBot);
          addChild(goodBot);
        }
      
    }
  }

  public function deleteMap()
  {
    for (i in 0...walls.length){
      removeChild(walls[i]);
      walls[i] = null;
    }
    walls = null;
  }
}