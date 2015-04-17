import starling.core.Starling;
import starling.events.*;
import flash.ui.Keyboard;

import Character;
import flash.sensors.Accelerometer;
import flash.events.AccelerometerEvent;

class MotionEngine {

	public var player:Character;
	private var accl:Accelerometer;
	var aX:Float;
	var aY:Float;
	var aZ:Float;
	var pX:Float;
 	var pY:Float;

	public function new (character:Character) {
		accl =  new Accelerometer();
		trace(Accelerometer.isSupported);

		this.player = character;

		aX = 0;
		aY = 0;
		checksupport(); //sets up event listener for motion

	}

	function checksupport() {
		if (Accelerometer.isSupported) {
			accl.addEventListener(AccelerometerEvent.UPDATE, updateHandler);
		} else {
			player.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			//player.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			player.addEventListener(Event.ENTER_FRAME, function()
				{
					pX = player.x += aX;
					pY = player.y += aY;
					boundaryCheck();

					Starling.juggler.tween(player, .01,
						{
							x: pX, y : pY,
						});
				});
		}
	}

	function updateHandler(evt:AccelerometerEvent) {
 
		aX = evt.accelerationX;
		aY = evt.accelerationY;
		aZ = evt.accelerationZ;
 
 		pX = player.x - aX * 100;
 		pY = player.y + (aY - .5)* 100;
 		boundaryCheck();

 		//move player
		Starling.juggler.tween(player, .01,
		{
			x: pX, y : pY,
		});


		//trace(aX);
		//trace(aY);
		//trace(aZ);
	}

	function boundaryCheck(){
		//keep player on screen
 		if (pX > (Starling.current.stage.stageWidth - player.width) ){
 			pX = Starling.current.stage.stageWidth - player.width;
 			aX = 0;
 		}
 		if (pX < 0 ){
 			pX = 0;
 			aX = 0;
 		}
 		if (pY > (Starling.current.stage.stageHeight - player.height) ){
 			pY = Starling.current.stage.stageHeight- player.height;
 			aY = 0;
 		}
 		if (pY < 0 ){
 			pY = 0;
 			aY = 0;
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