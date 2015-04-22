import starling.animation.Tween;
import starling.animation.Transitions;
import flash.display3D.textures.Texture;
import starling.textures.TextureAtlas;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.EnterFrameEvent;
import starling.utils.AssetManager;

import haxe.Timer;
import GameDriver;

class Game extends Sprite {
	// LOCAL VARS
	
	// Global asset manager and atlas
	public static var assets:AssetManager;
	public var atlas:TextureAtlas;
	
	// Game driver reference
	public var gameDriver:GameDriver;
	
	// Callback when the game is over
	public var gameOver:Bool->Void = null;
	
	// Timer to spawn the object
	var spawner:Timer = null;
	
	// Misc
	public var paused:Bool = false;
	
	// Game characters
	public var hero:Character;
	public var badBot:Character;
	public var goodBot:Character;
	public var botList:List<Sprite> = new List<Sprite>();
	
	// Motion engine
	public var engine:MotionEngine;
	
	// Constructor
	function new(game_driver:GameDriver, game_assets:AssetManager) {
		super();
		
		// Set game driver
		gameDriver = game_driver;
		
		// Set asset manager
		assets = game_assets;
		
		// Set texture atlas
		atlas = assets.getTextureAtlas("sprite_atlas");
		
		this.addEventListener(Event.ADDED_TO_STAGE, function() {
			// on enter frame, run onEnterFrame method to start the game
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			
			spawner = new Timer(500);
			spawner.run = spawnBots;
		});
		
		this.addEventListener(Event.REMOVED_FROM_STAGE, function () {
			if(spawner != null)
				spawner.stop();
		});
		
		// Set and add game hero character
		hero = new Character(1, atlas.getTextures("spaceship_hero"), gameDriver);
		hero.setHealthBar(assets.getTexture("health_bar0001"));
		hero.x = 535;
		hero.y = 450;
		hero.makeStand();
        addChild(hero);
		
        engine = new MotionEngine(hero);
		
		// End of constructor
	}
	
	public function onEnterFrame(event:EnterFrameEvent) {
		// if game is paused return
		if (paused)
			return;
			
		hitDetection();
			
		// work in progress...
		
	}
	
	/** Simple hit detection */
	private function hitDetection() {
		if(badBot != null)
			if (badBot.bounds.intersects(hero.bounds)) {
				hero.processBotCollision(badBot.botType);
				//removeChild(badBot, true);
				//badBot = null;
				trace("hit-bad");				
			}
			
		if(goodBot != null)
			if (goodBot.bounds.intersects(hero.bounds)) {
				hero.processBotCollision(goodBot.botType);
				//removeChild(goodBot, true);
				//goodBot = null;
				trace ("hit-good");
			}
		
		// work in progress...
	}
	
	private function spawnBots() {
		if (paused)
			return;
			
		if(spawner != null)
			spawner.stop();
			
		// Set and add badbot character placeholder
		badBot = new Character(2, atlas.getTextures("bad_botA"), gameDriver);
		badBot.x = 200;
		badBot.y = 268;
		addChild(badBot);
		
		// Set and add goodbot character placeholder
		goodBot = new Character(3, atlas.getTextures("good_botA"), gameDriver);
		goodBot.x = 400;
		goodBot.y = 268;
		addChild(goodBot);
		
		// work in progress...
	}
}