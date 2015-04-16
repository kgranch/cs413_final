import starling.core.Starling;

import Character;
import flash.sensors.Accelerometer;
import flash.events.AccelerometerEvent;

class MotionEngine {

	public var player:Character;
	private var accl:Accelerometer;
	var aX:Float;
	var aY:Float;
	var aZ:Float;

	public function new (character:Character) {
		accl =  new Accelerometer();
		trace(Accelerometer.isSupported);

		this.player = character;

		checksupport(); //sets up event listener for motion

	}

	function checksupport() {
		if (Accelerometer.isSupported) {
			accl.addEventListener(AccelerometerEvent.UPDATE, updateHandler);
		} else {
			trace(Accelerometer.isSupported);
		}
	}

	function updateHandler(evt:AccelerometerEvent) {
 
		aX = evt.accelerationX;
		aY = evt.accelerationY;
		aZ = evt.accelerationZ;
 
 		var pX = player.x - aX * 50;
 		var pY = player.y + (aY - .5)* 50;


 		//keep player on screen
 		if (pX > (Starling.current.stage.stageWidth - player.width) ){
 			pX = Starling.current.stage.stageWidth - player.width;
 		}
 		if (pX < 0 ){
 			pX = 0;
 		}
 		if (pY > (Starling.current.stage.stageHeight - player.height) ){
 			pY = Starling.current.stage.stageHeight- player.height;
 		}
 		if (pY < 0 ){
 			pY = 0;
 		}

 		//move player
		Starling.juggler.tween(player, .01,
		{
			x: pX, y : pY,
		});




		//trace(aX);
		//trace(aY);
		//trace(aZ);
	}
}