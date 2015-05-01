import starling.core.Starling;
import starling.display.Sprite;
import starling.textures.Texture;

import MovieClipPlus;
import Game; //Trying to get the bots in


class Character extends MovieClipPlus {
	// LOCAL VARS
	
	// Game driver reference
	public var gameDriver:GameDriver;
	
	// Bot types
	public var heroBotType:Int = 1;
	public var badBotType:Int = 2;
	public var goodBotType:Int = 3;
	
	// Game character stats
	public var botType:Int;
	public var heroScore:Int;
	
	/** Constructor */
	public function new (botType:Int, textures:flash.Vector<Texture>, gameDriver:GameDriver, fps:Int=6) {
		super(textures, fps);
		this.botType = botType;
		this.gameDriver = gameDriver;
		
		if(botType == heroBotType) {
			this.initializeHero();
		}
		else if(botType == badBotType) {
			this.initializeBadBot();
		}
		else if(botType == goodBotType) {
			this.initializeGoodBot();
		}
	}

	/** Create and return game hero */
	public function initializeHero() {
		// rescale character's width/height
		this.scaleX = .35;
		this.scaleY = .35;
		
		// add character to juggler for movie, then stop playback immediately
		Starling.juggler.add(this);
        this.stop();
		
		// initialize hero's score
		heroScore = 0;
	}

	/** Create and return game bad bot */
	public function initializeBadBot() {
		// rescale character's width/height
		this.scaleX = .35;
		this.scaleY = .35;
		
		// add character to juggler for movie, then stop playback immediately
		Starling.juggler.add(this);
        this.stop();
		
		// make bot stand
		this.setNext(3, 0);
		this.gotoAndPlay(0);
	}

	/** Create and return game good bot */
	public function initializeGoodBot() {
		// rescale character's width/height
		this.scaleX = .35;
		this.scaleY = .35;
		
		// add character to juggler for movie, then stop playback immediately
		Starling.juggler.add(this);
        this.stop();
		
		// make bot stand
		this.setNext(3, 0);
		this.gotoAndPlay(0);
	}
	
	public function makeStand() {
		// make hero stand
		this.setNext(5, 3);
		this.gotoAndPlay(0);
	}
	
	public function makeMoveForward() {
		// make hero move forward
		this.setNext(11, 9);
		this.gotoAndPlay(6);
	}
	
	public function makeDizzy() {
		// make hero dizzy
		this.setNext(17, 15);
		this.gotoAndPlay(12);
	}
	
	public function makeMoveLeft() {
		// make hero move left
		this.setNext(23, 21);
		this.gotoAndPlay(18);
	}
	
	public function makeMoveRight() {
		// make hero move right
		this.setNext(29, 27);
		this.gotoAndPlay(24);
	}
}