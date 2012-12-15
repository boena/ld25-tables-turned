
package entities.tasks;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Sfx;

import enums.TaskState;

class TaskEntity extends Entity {

	private var _sprite : Spritemap;
	public var state : TaskState;
	public var durationInMs : Int = 1000;

	private var _completionTimer : Int;

	public function completeTask()
	{
			_completionTimer = nme.Lib.getTimer();
	}

	public override function update()
	{

		if(_completionTimer > 0)
		{  
			trace(nme.Lib.getTimer());
			if(nme.Lib.getTimer() > _completionTimer + durationInMs)
			{
				_completionTimer = 0;
				_sprite.play("idle_done");
			}
			else
				_sprite.play("idle_unfinished");
		}

		super.update();
	}
}