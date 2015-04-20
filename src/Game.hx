import flash.display3D.textures.Texture;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.EnterFrameEvent;
import starling.utils.AssetManager;

import GameDriver;

class Game extends Sprite {
	// LOCAL VARS
	
	// Global asset manager
	public static var assets:AssetManager;
	
	// Game driver reference
	public var gameDriver:GameDriver;
	
	// Callback when the game is over
	public var gameOver:Bool->Void = null;
	
	// Misc
	public var paused:Bool = false;
	
	// Game characters
	public var hero:Character;
	
	// Motion engine
	public var engine:MotionEngine;
	
	// Constructor
	function new(game_driver:GameDriver, game_assets:AssetManager) {
		super();
		
		// Set game driver
		gameDriver = game_driver;
		
		// Set asset manager
		assets = game_assets;
		
		this.addEventListener(Event.ADDED_TO_STAGE, function() {
			// on enter frame, run onEnterFrame method to start the game
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		});
		
		this.addEventListener(Event.REMOVED_FROM_STAGE, function () {
			// do nothing at the moment
		});
		
		// Set and add game hero character
		var atlas = assets.getTextureAtlas("sprite_atlas");
		hero = new Character(1, atlas.getTextures("spaceship_front"), gameDriver);
		hero.setHealthBar(assets.getTexture("health_bar0001"));
		hero.makeStand();
		hero.x = 535;
		hero.y = 450;
        addChild(hero);
        var engine = new MotionEngine(hero);
		
		// end of constructor
	}
	
	public function onEnterFrame(event:EnterFrameEvent) {
		// if game is paused return
		if (paused)
			return;
			
		var atlas = assets.getTextureAtlas("sprite_atlas");
		
		// Set and add badbot character placeholder 
		var badBot = new Character(2, atlas.getTextures("bad_botA"), gameDriver);
		badBot.x = 200;
		badBot.y = 268;
        addChild(badBot);
		
		// Set and add goodbot character placeholder 
		var goodBot = new Character(3, atlas.getTextures("good_botA"), gameDriver);
		goodBot.x = 400;
		goodBot.y = 268;
        addChild(goodBot);
			
		// do nothing else at the moment
		
		return;
	}
}