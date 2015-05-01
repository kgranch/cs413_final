import starling.animation.Tween;
import starling.animation.Transitions;
import starling.display.MovieClip;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Image;
import starling.display.Quad;
import starling.core.Starling;
import starling.events.KeyboardEvent;
import flash.ui.Keyboard;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.display.Button;
import starling.events.Event;
import starling.textures.Texture;
import starling.events.EnterFrameEvent;
import starling.display.Stage;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import starling.text.TextField;
import starling.utils.RectangleUtil;
import flash.geom.Rectangle;

import MovieClipPlus;
import Tilemap;
import Character;
import MotionEngine;
import Game;

class GameDriver extends Sprite {
	// Global assets manager and atlas
	public static var assets:AssetManager;
	public var atlas:TextureAtlas;
	
	// Game manager
	public var gameManager:Game;

	// Keep track of the stage
	static var globalStage:Stage = null;
	
	// In game text objects
	public var gameTitleText:TextField;
	
	// Interactive Buttons
	var startButton:Button;
	var mainMenuButton:Button;
	var creditsButton:Button;
	var tutorialButton:Button;
	
	// Menu Screens
	var mainScreen:Image;
	var creditsScreen:Image;
	var tutorialScreen:Image;
	var gameScreen:Image;
	
	// Music
	var shoot:Sound;
	var gameMusic:Sound;
	
	/** Constructor */
	public function new() {
		super();
	}
	
	/** Function used to load in any assets to be used during the game */
	private function populateAssetManager() {
		assets = new AssetManager();
		
		// game buttons
		assets.enqueue("assets/mainMenuButton.png");
		assets.enqueue("assets/startButton.png");
		assets.enqueue("assets/creditsButton.png");
		assets.enqueue("assets/tutorialButton.png");
		
		// game screens
		assets.enqueue("assets/mainScreen.png");
		assets.enqueue("assets/tutorialScreen.png");
		assets.enqueue("assets/creditsScreen.png");
		assets.enqueue("assets/gameScreen.png");
		assets.enqueue("assets/gameoverScreen.png");
		assets.enqueue("assets/gamewinScreen.png");
		
		// game font
		assets.enqueue("assets/gameFont01.fnt");
		assets.enqueue("assets/gameFont01.png");
		assets.enqueue("assets/mainMenuFont01.fnt");
		assets.enqueue("assets/mainMenuFont01.png");
		assets.enqueue("assets/creditsFont01.fnt");
		assets.enqueue("assets/creditsFont01.png");
		assets.enqueue("assets/tutorialFont01.fnt");
		assets.enqueue("assets/tutorialFont01.png");
		
		// game sprite atlas
		assets.enqueue("assets/sprite_atlas.xml");
		assets.enqueue("assets/sprite_atlas.png");
		
		// game music and sounds
		assets.enqueue("assets/sounds/fall.mp3");
		assets.enqueue("assets/sounds/hitenemy.mp3");
		assets.enqueue("assets/sounds/shot.mp3");
		assets.enqueue("assets/sounds/tripleshot.mp3");
		assets.enqueue("assets/sounds/tstmusic.mp3");
		assets.enqueue("assets/sounds/marimba.mp3");

		//tilemap and tiles
		assets.enqueue("assets/wall.png");

	}

	/** Function called from the initial driver, sets up the root class */
	public function start(startup:GameLoader, startupStage:Stage) {
		// Prep all asset paths
		populateAssetManager();
		
		var names = assets.getTextureNames();
		for (name in names) {
			trace(name);
		}

		// Set the global stage to the starling stage
		globalStage = startupStage;
		
		// Start loading in the assets
		assets.loadQueue(function onProgress(ratio:Int) {
			if (ratio == 1) {	
				startScreen();

				// Fade out the loading screen since everything is loaded
				Starling.juggler.tween(startup.loadingBitmap, 1, {
					transition: Transitions.EASE_OUT,
					delay: 3,
					alpha: 0,
					onComplete: function() {
					startup.removeChild(startup.loadingBitmap);
					GameDriver.assets.playSound("marimba", 0, 9999);
				}});
			}
		});
        
	}

	/** Do stuff with the menu screen */
	private function startScreen() {
		// Clear the stage
		this.removeChildren();
		
		mainScreen = new Image(GameDriver.assets.getTexture("mainScreen"));
		addChild(mainScreen);
		
		// Set and display game title
		gameTitleText = installText(0,20, "Spacey Maze", "mainMenuFont01", 55, "center");
		addChild(gameTitleText);
		
		// Set and add start game button
		startButton = installStartGameButton(940, -15);
		addChild(startButton);
		
		tutorialButton = installTutorialButton(815, 330);
		addChild(tutorialButton);
		
		creditsButton = installCreditsButton(90, 430);
		addChild(creditsButton);
		
		
	}

	/** Function to be called when we are ready to start the game */
	private function startGame() {
		// Clear the stage
		this.removeChildren();
		
		// Set and display game screen background
		gameScreen = new Image(GameDriver.assets.getTexture("gameScreen"));
		addChild(gameScreen);
		
		// Set and add game manager
		gameManager = new Game(this, assets);
		gameManager.gameOver = triggerGameOver;
		gameManager.paused = false;
		addChild(gameManager);

		// Set and add mainMenu button
		mainMenuButton = installMainMenuButton(15, 15);
		mainMenuButton.scaleX = .50;
		mainMenuButton.scaleY = .50;
		addChild(mainMenuButton);
			
		return;
	}

	/** Display the rules menu */
	private function viewTutorial() {
		// local vars
		var titleText:TextField;
		var tutorialText:String = "";
		var gameTutorialText:TextField;
		
		// Clear the stage
		this.removeChildren();
		
		tutorialScreen = new Image(GameDriver.assets.getTexture("tutorialScreen"));
		addChild(tutorialScreen);
		
		// Set and display game tutorial title
		titleText = installText(0,20, "Game Tutorial", "tutorialFont01", 55, "center");
		addChild(titleText);
		
		// Set and display game designers
		tutorialText += "This is how you play the game.\n";
		tutorialText += "    On a computer, use arrow keys to move.\n";
		tutorialText += "    On Android, tilt the device to move\n";
		tutorialText += "    Avoid the gold bots. Pick up 10 purple\n    bots to win.";
		
		gameTutorialText = installText(100,350, tutorialText, "tutorialFont01", 40, "left", "bothDirections");
		addChild(gameTutorialText);
	
		// Set and add mainMenu button
		mainMenuButton = installMainMenuButton(20, 20);
		addChild(mainMenuButton);
		return;
	}
	
	/** Function to be called when looking at the credits menu*/
	private function viewCredits() {
		// local vars
		var titleText:TextField;
		var designerText:String = "";
		var gameDesignerText:TextField;
		
		// Clear the stage
		this.removeChildren();
		
		creditsScreen = new Image(GameDriver.assets.getTexture("creditsScreen"));
		addChild(creditsScreen);
		
		// Set and display game credits title
		titleText = installText(0,20, "Game Developers", "creditsFont01", 55, "center");
		addChild(titleText);
		
		// Set and display game designers
		designerText += "Waylon Dixon\n";
		designerText += "Kyle Granchelli\n";
		designerText += "Cate Holcomb\n";
		designerText += "Justin Liddicoat\n";
		designerText += "Zachary Patten\n";
		
		gameDesignerText = installText(0,200, designerText, "creditsFont01", 35, "center");
		addChild(gameDesignerText);
	
		// Set and add mainMenu button
		mainMenuButton = installMainMenuButton(20, 20);
		addChild(mainMenuButton);	
		return;
	}
	
	/** Called when the game is over */
	public function triggerGameOver(winGame:Bool) {
		this.removeChildren();
		startScreen();
		
		// local vars
		var container = new Sprite();
		var displayText:TextField = null;
		var bg:Image;
		
		if (!winGame){
			displayText = installText(470, 125, "You lose!", "creditsFont01", 65);
			bg = new Image(assets.getTexture("gameoverScreen"));
		} else {
			displayText = installText(470, 125, "You Win!", "gameFont01", 65);
			bg = new Image(assets.getTexture("gamewinScreen"));
		}
		
		container.addChild(bg);
		container.addChild(displayText);
		addChild(container);
		
		Starling.juggler.tween(container, 2, {
			transition: Transitions.EASE_OUT,
			delay: 4,
			alpha: 0,
			onComplete: function(){
				startScreen();
			}
		});
		
		return;
	}
	
	/** Restart the game */
	private function restartGame(){
		this.removeChildren();
		startGame();
	}
	
	/** Install game text **/
	public function installText(x:Int, y:Int, myText:String, myFont:String, myFontsize:Int, myHAlign:String = "left", myAutoSize:String = "vertical") {
		// local vars
		var gameText:TextField;
		
		// note: possible values for parameters:
		// myHAlign: left, right, center
		// myAutoSize: vertical, horizontal, bothDirections, none
		
		gameText = new TextField(globalStage.stageWidth, globalStage.stageHeight, myText);
		gameText.fontName = myFont;
		gameText.fontSize = myFontsize;
		gameText.color = 0xffffff;
		gameText.hAlign = myHAlign;
		gameText.autoSize = myAutoSize;
		gameText.x = x;
		gameText.y = y;
		
		return gameText;
	}
	
	/** Install start game button at (x,y) coordinates */
	function installStartGameButton(x:Int, y:Int) {
		var sgButton:Button;
						
		sgButton = new Button(GameDriver.assets.getTexture("startButton"));
		sgButton.x = x;
		sgButton.y = y;
		
		// On button press, display game screen
		sgButton.addEventListener(Event.TRIGGERED, startGame);
		
		// Return start game button
		return sgButton;
	}
	
	/** Install game tutorial button at (x,y) coordinates */
	function installTutorialButton(x:Int, y:Int) {
		var tButton:Button;
						
		tButton = new Button(GameDriver.assets.getTexture("tutorialButton"));
		tButton.x = x;
		tButton.y = y;
		
		// On button press, display tutorial
		tButton.addEventListener(Event.TRIGGERED, viewTutorial);
		
		// Return tutorial button
		return tButton;
	}
	
	
	/** Install game tutorial button at (x,y) coordinates */
	function installCreditsButton(x:Int, y:Int) {
		var cButton:Button;
						
		cButton = new Button(GameDriver.assets.getTexture("creditsButton"));
		cButton.x = x;
		cButton.y = y;
		
		// On button press, display tutorial
		cButton.addEventListener(Event.TRIGGERED, viewCredits);
		
		// Return tutorial button
		return cButton;
	}
	
	/** Install main menu button at (x,y) coordinates */
	function installMainMenuButton(x:Int, y:Int) {		
		var mmButton:Button;
		
		// Make main menu button and set location
		mmButton = new Button(GameDriver.assets.getTexture("mainMenuButton"));
		mmButton.x = x;
		mmButton.y = y;
	
		// On button press, display the main menu
		mmButton.addEventListener(Event.TRIGGERED, startScreen);
		
		// Return main menu button
		return mmButton;
	}
	
	// Check Collision
    private function checkCollision(texture1:Image, texture2:Rectangle):Bool {
        return (texture1.bounds.intersects(texture2));
    }

    

}
