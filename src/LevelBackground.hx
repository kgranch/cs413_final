import starling.display.Sprite;
import starling.events.Event;

import BackgroundLayer;
import MotionEngine;

class LevelBackground extends Sprite{

	//list of all the layers in this level
	private var layers:Array<BackgroundLayer> = new Array();
	public var engine:MotionEngine;

	//must have all the level's layers created before creating the level
	public function new(layers:Array<BackgroundLayer>){
		super();
		this.layers = layers;
		this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	private function onAddedToStage(event:Event){
		this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		for (i in 0...layers.length){
			this.addChild(layers[i]);
		}

		this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private function onEnterFrame(event:Event){

		//move each layer on every frame based on its speed and the player's motion
		if (engine != NULL){
			for(i in 0...layers.length){
				layers[i].x -= layers[i].speed * engine.aX;
				layers[i].y -= layers[i].speed * engine.aY;

				if (layers[i].x < -stage.stageWidth){
					layers[i].x = 0;
				}
				if (layers[i].y < -stage.stageHeight){
					layers[i].y = 0;
				}
				if (layers[i].x > stage.stageWidth){
					layers[i].x = 0;
				}
				if (layers[i].y > stage.stageHeight){
					layers[i].y = 0;
				}
			}
		}
	}

}