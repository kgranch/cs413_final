import starling.core.Starling;
import starling.events.*;
import flash.ui.Keyboard;

import Character;
import Game;
import flash.sensors.Accelerometer;
import flash.events.AccelerometerEvent;

class MotionEngine {

	public var player:Character;
	public var badBot:Character;
	public var goodBot:Character;
	public var map:Tilemap;
	private var accl:Accelerometer;
	public var aX:Float;
	public var aY:Float;
	var aZ:Float;
	var pX:Float;
 	var pY:Float;
 	var cx:Float;
 	var cy:Float;

	public function new (character:Character, map:Tilemap) {
		accl =  new Accelerometer();

		this.player = character;
		this.map = map;

		aX = 0;
		aY = 0;

		cx = Starling.current.stage.stageWidth / 2;
		cy = Starling.current.stage.stageHeight / 2;

		checksupport(); //sets up event listener for motion

	}

	public function moveEngine(evt:EnterFrameEvent){
		map.x = map.x + aX ;
 		map.y = map.y + aY;
 		boundaryCheck();
	}

	function checksupport() {
		if (Accelerometer.isSupported) {
			accl.addEventListener(AccelerometerEvent.UPDATE, updateHandler);
			player.addEventListener(Event.ENTER_FRAME, moveEngine);
		} else {
			player.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			//player.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			player.addEventListener(Event.ENTER_FRAME, function()
				{
					//pX = player.x += aX;
					//pY = player.y += aY;
					map.x -= aX;
					map.y -= aY;
					boundaryCheck();

					/*Starling.juggler.tween(player, .01,
						{
							x: pX, y : pY,
						});*/
				});
		}
	}

	function updateHandler(evt:AccelerometerEvent) {
 
		aX = evt.accelerationX * 100;
		aY = - (evt.accelerationY - .5) * 100;
		aZ = evt.accelerationZ;
 
 		//pX = player.x - aX * 100;
 		//pY = player.y + (aY - .5)* 100;
 		
	}

	function boundaryCheck(){
		//keep player on screen
 		if (pX > (Starling.current.stage.stageWidth - player.width/2) ){
 			pX = Starling.current.stage.stageWidth - player.width/2;
 			aX = 0;
 		}
 		if (pX < 0 ){
 			pX = player.width/2;
 			aX = 0;
 		}
 		if (pY > (Starling.current.stage.stageHeight - player.height/2) ){
 			pY = Starling.current.stage.stageHeight- player.height/2;
 			aY = 0;
 		}
 		if (pY < 0 ){
 			pY = player.height/2;
 			aY = 0;
 		}

 		//keep camera on tilemap
 		if (map.x < -(6400 - Starling.current.stage.stageWidth/2)){
 			map.x = -(6400 - Starling.current.stage.stageWidth/2);
 		}
 		if (map.y < -(6400 - Starling.current.stage.stageHeight/2)){
 			map.y = -(6400 - Starling.current.stage.stageHeight/2);
 		}
 		if (map.x > (Starling.current.stage.stageWidth/2)){
 			map.x = Starling.current.stage.stageWidth/2;
 		}
 		if (map.y > (Starling.current.stage.stageHeight/2)){
 			map.y = Starling.current.stage.stageHeight/2;
 		}

	}

	function keyDownHandler(e:KeyboardEvent){
		{
			switch(e.keyCode)
			{
				case Keyboard.UP:
					if (aY <= 0) aY -= 1;
					else aY = -1;
				case Keyboard.DOWN:
					if (aY >= 0) aY += 1;
					else aY = 1;
				case Keyboard.LEFT:
					if (aX <= 0) aX -= 1;
					else aX = -1;
				case Keyboard.RIGHT:
					if (aX >= 0) aX += 1;
					else aX = 1;
			}
		}
	}

	function keyUpHandler(e:KeyboardEvent){
		{
			switch(e.keyCode)
			{
				case Keyboard.UP:
					 this.aY = 0;
				case Keyboard.DOWN:
					 this.aY = 0;
				case Keyboard.LEFT:
					 this.aX = 0;
				case Keyboard.RIGHT:
					 this.aX = 0;
			}
		}
	}

}