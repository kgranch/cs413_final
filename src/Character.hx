﻿import starling.core.Starling;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.display.Image;
import starling.text.TextField;

import MovieClipPlus;
import HealthBar;

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
	public var healthBar:HealthBar;
	public var heroScore:Int;
	public var scoreText:TextField;
	public var winningScore:Int = 2000;
	
	/** Constructor */
	public function new (botType:Int, textures:flash.Vector<Texture>, gameDriver:GameDriver, fps:Int=8) {
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
		this.scaleX = .35;
		this.scaleY = .35;
		
		Starling.juggler.add(this);
        this.stop();
		
		// initialize hero's score
		heroScore = 0;
		
		// Set and display score
		scoreText = gameDriver.installText(975, 10, "Score: "+heroScore, "gameFont01", 45);
		gameDriver.addChild(scoreText);
	}

	/** Create and return game bad bot */
	public function initializeBadBot() {
		this.scaleX = .35;
		this.scaleY = .35;
		
		Starling.juggler.add(this);
        this.stop();
	}

	/** Create and return game good bot */
	public function initializeGoodBot() {
		this.scaleX = .35;
		this.scaleY = .35;
		
		Starling.juggler.add(this);
        this.stop();
	}
	
	public function setHealthBar(healthBarTexture:Texture) {
		healthBar = new HealthBar(400,25,healthBarTexture);
		healthBar.defaultColor = healthBar.color;
		healthBar.x = gameDriver.stage.stageWidth/2 - healthBar.maxWidth/2;
		healthBar.y = 25;
		
		var tHealthbar = new Image(healthBarTexture);
		tHealthbar.width = healthBar.maxWidth;
		tHealthbar.height = healthBar.height;
		tHealthbar.x = healthBar.x;
		tHealthbar.y = healthBar.y;
		tHealthbar.alpha = 0.2;
			
		gameDriver.addChild(tHealthbar);
		gameDriver.addChild(healthBar);
	}
	
	public function processBotCollision(bot_type:Int){
		var currentSpan = healthBar.getBarSpan();
		
		if(bot_type == goodBotType){
			//rightAnsSound.play();
			
			// increment's hero's score
			heroScore += 1;
			
			// if hero collects X number of goodbots, then display win game
			if (heroScore >= winningScore){
				gameDriver.triggerGameOver(true);
				return;
			}
			
			gameDriver.removeChild(scoreText, true);
			scoreText = gameDriver.installText(975, 10, "Score: "+heroScore, "gameFont01", 45);
			gameDriver.addChild(scoreText);
			
			healthBar.animateBarSpan(currentSpan + 0.1, 0.015);
			healthBar.flashColor(0x00FF00, 30);
		} 
		else if(bot_type == badBotType) {
			//wrongAnsSound.play();
			
			makeDizzy();
			
			Starling.juggler.tween(this, 1, {
				delay: 1,
				onComplete: function() {
					makeStand();
			}});
			
			healthBar.animateBarSpan(currentSpan - 0.1, 0.015);
			healthBar.flashColor(0xFF0000, 30);
			
			if(healthBar.getBarSpan() < 0.1){
				gameDriver.triggerGameOver(false);
			}
		}
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