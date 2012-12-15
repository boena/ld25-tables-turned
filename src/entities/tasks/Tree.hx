
package entities.tasks;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;

import enums.TaskState;

class Tree extends TaskEntity, implements ITask {

	public var durationInMs : Int = 1000;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		
		_sprite = new Spritemap("gfx/tree.png", 64, 128);
		_sprite.add("idle_unfinished", [0]);
		_sprite.add("idle_done", [0]);
		_sprite.play("idle_unfinished");
		graphic = _sprite;
		
		type = 'tree';
								
		setHitboxTo( _sprite );
	}

}