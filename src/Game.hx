import starling.animation.Tween;
import starling.animation.Transitions;
import flash.display3D.textures.Texture;
import starling.textures.TextureAtlas;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.EnterFrameEvent;
import starling.utils.AssetManager;
import starling.core.Starling;
import flash.sensors.Accelerometer;
import flash.geom.Point;
import starling.text.TextField;
import starling.display.Image;


import haxe.Timer;
import GameDriver;
import Tilemap;
import HealthBar;

class Game extends Sprite {
	// LOCAL VARS

	//Raidians for collision detection
	static var PI14 = Math.PI / 4;
	static var PI34 = 3 * Math.PI / 4;
	static var PI54 = 3 * Math.PI / 4;
	static var PI74 = 3 * Math.PI / 4;

	
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
	public var scoreText:TextField;
	public var winningScore:Int = 10;
	public var healthBar:HealthBar;
	
	// Game characters
	public var hero:Character;
	public var goodBotList:List<Character> = new List<Character>();
	public var badBotList:List<Character> = new List<Character>();
	
	// Bot types
	public var heroBotType:Int = 1;
	public var badBotType:Int = 2;
	public var goodBotType:Int = 3;
	
	// Motion engine
	public var engine:MotionEngine;

	//tilemaps
	var mapone:Tilemap; 
	var levels:Levels = new Levels();
	
	// Constructor
	function new(game_driver:GameDriver, game_assets:AssetManager) {
		super();
		
		// Set game driver
		gameDriver = game_driver;
		
		// Set asset manager
		assets = game_assets;
		
		// Set texture atlas
		atlas = assets.getTextureAtlas("sprite_atlas");

		//create tilemap
        mapone = new Tilemap(levels.levelone, gameDriver);
		addChild(mapone);
		
		this.addEventListener(Event.ADDED_TO_STAGE, function() {
			// on enter frame, run onEnterFrame method to start the game
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			
		});

		// Set and add game hero character
		hero = new Character(1, atlas.getTextures("spaceship_hero"), gameDriver);
		//hero.alignPivot();
		hero.x = Starling.current.stage.stageWidth/2;
		hero.y = Starling.current.stage.stageHeight/2;
		hero.makeStand();
        addChild(hero);
		
		// set the healthbar and scoreboard
		setHealthBar();
		setScoreBoard();
		
        engine = new MotionEngine(hero,mapone);
		
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
		//for wall hits, get hero's position on stage

		var hpivot = hero.localToGlobal(new Point(hero.pivotX, hero.pivotY));
		var wpivot = new Point();
		var collisionVector = new Point();
		var unitVector = new Point(1,0);

		// hit detection for badbots
		for (badBot in mapone.badBotList) {
			if (badBot.getBounds(badBot.parent.parent).intersects(hero.getBounds(hero.parent)) && badBot != null) {
				processBotCollision(badBot.botType);
				removeChild(badBot, true);
				badBot.x = -10000;
				badBot.y = -10000;
				badBot = null;			
			}
		}
		
		// hit detection for goodbots
		for (goodBot in mapone.goodBotList) {
			if (goodBot.getBounds(goodBot.parent.parent).intersects(hero.getBounds(hero.parent)) && goodBot != null) {
				processBotCollision(goodBot.botType);
				removeChild(goodBot, true);
				goodBot.x = -10000;
				goodBot.y = -10000;
				goodBot = null;	
			}
		}


		//wall collision detection
		for (wall in mapone.walls) {
			if (wall.getBounds(wall.parent.parent).intersects(hero.getBounds(hero.parent)) && wall != null) {
				if(Accelerometer.isSupported){

					/*
					//get the walls position on stage
					wpivot.setTo(wall.pivotX, wall.pivotY); 
					wall.localToGlobal(wpivot,wpivot);

					var dx = hpivot.x - wpivot.x;
					var dy = hpivot.y - wpivot.y;
					var angle = Math.atan2(dy,dx);

					if(dx > 0) dx -= wall.width;
					//else dx += wall.width;
					if(dy > 0) dy -= wall.height;
					//else dy += wall.height;


					mapone.x = mapone.x + dx;
					mapone.y = mapone.y + dy;

					
					//check to see if hero is above/below/left/right of wall
					if(angle < PI14 || angle >= PI74){
						//hero hit wall from right
						mapone.x -= dx;
						
					} else if (angle >= PI14 && angle < PI34){
						//hero hit wall from above
						mapone.y -= dy;

					} else if (angle >= PI34 && angle < PI74){
						//hero hit wall from left
						mapone.x -= dx;

					} else if (angle >= PI34 && angle < PI74){
						//hero hit wall from above
						mapone.y -= dy;

					}
					*/
					
					//get the walls position on stage
					wpivot.setTo(wall.pivotX, wall.pivotY); 
					wall.localToGlobal(wpivot,wpivot);

					var dx = wpivot.x - hpivot.x;
					var dy = wpivot.y - hpivot.y;

					//check to see if hero
					if((dx > 0 && engine.aX > 0) || (dx < 0 && engine.aX < 0)){
						dx = - engine.aX;
					} 

					if((dy > 0 && engine.aY > 0) || (dy < 0 && engine.aY < 0)){
						dy = - engine.aY;
					} 

					if(dx > 0) dx -= hero.width;
					if(dy > 0) dy -= hero.width;

					mapone.x = mapone.x + dx;
					mapone.y = mapone.y + dy;


				}else{
					engine.aX = -engine.aX;
					engine.aY = -engine.aY;
				}

				
			}
		}
		
		// work in progress...
	}
	
	private function spawnBots() {
		if (paused)
			return;
		
		if(spawner != null)
			spawner.stop();
		
		// Spawn Bad bots
		var badbotCount = 0;
		var badbotMaxCount = 5;
		
		while (badbotCount < badbotMaxCount) {
			// Set and add badbot character
			var badBot = new Character(2, atlas.getTextures("bad_botA"), gameDriver);
			badBot.x = Math.random()*(this.stage.stageWidth-100) + 50;
			badBot.y = Math.random()*(this.stage.stageHeight-100) + 50;
			addChild(badBot);
			
			badBotList.add(badBot);
			
			// increment counter
			badbotCount++;
		}
		
		// Spawn good bots
		var goodbotCount = 0;
		var goodbotMaxCount = 10;
		
		while (goodbotCount < goodbotMaxCount) {
			// Set and add badbot character
			var goodBot = new Character(3, atlas.getTextures("good_botA"), gameDriver);
			goodBot.x = Math.random()*(this.stage.stageWidth-100) + 50;
			goodBot.y = Math.random()*(this.stage.stageHeight-100) + 50;
			addChild(goodBot);
			
			goodBotList.add(goodBot);
			
			// increment counter
			goodbotCount++;
		}
		
		// work in progress...
	}
	
	public function setScoreBoard() {
		// Set and display score
		scoreText = gameDriver.installText(975, 10, "Score: "+hero.heroScore, "gameFont01", 45);
		addChild(scoreText);
		
		return;
	}
	
	public function setHealthBar() {
		// local vars
		var healthBarTexture = assets.getTexture("health_bar0001");
		var tHealthbar;
		
		healthBar = new HealthBar(400, 25, healthBarTexture);
		healthBar.defaultColor = healthBar.color;
		healthBar.x = gameDriver.stage.stageWidth/2 - healthBar.maxWidth/2;
		healthBar.y = 25;
		
		tHealthbar = new Image(healthBarTexture);
		tHealthbar.width = healthBar.maxWidth;
		tHealthbar.height = healthBar.height;
		tHealthbar.x = healthBar.x;
		tHealthbar.y = healthBar.y;
		tHealthbar.alpha = 0.2;
			
		addChild(tHealthbar);
		addChild(healthBar);
		
		return;
	}
	
	public function processBotCollision(bot_type:Int){
		var currentSpan = healthBar.getBarSpan();
		
		if(bot_type == goodBotType){
			GameDriver.assets.playSound("goodbot", 1, 0);
			
			// increment's hero's score
			hero.heroScore += 1;
			
			// if hero collects X number of goodbots, then display win game
			if (hero.heroScore >= winningScore){
				gameDriver.triggerGameOver(true);
				return;
			}
			
			removeChild(scoreText, true);
			scoreText = gameDriver.installText(975, 10, "Score: "+hero.heroScore, "gameFont01", 45);
			addChild(scoreText);
			
			healthBar.animateBarSpan(currentSpan + 0.1, 0.015);
			healthBar.flashColor(0x00FF00, 30);
		} 
		else if(bot_type == badBotType) {
			GameDriver.assets.playSound("badbot", 1, 0);
			
			hero.makeDizzy();
			
			Starling.juggler.tween(hero, 1, {
				delay: 2,
				onComplete: function() {
					hero.makeStand();
			}});
			
			healthBar.animateBarSpan(currentSpan - 0.3, 0.015);
			healthBar.flashColor(0xFF0000, 30);
			
			if(healthBar.getBarSpan() < 0.1){
				gameDriver.triggerGameOver(false);
			}
		}
		
		return;
	}
}