
package entities.tasks;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Sfx;

import enums.TaskState;
import entities.Player;

class TaskEntity extends Entity {

	private var _sprite : Spritemap;
	public var state : TaskState;
	public var durationInMs : Int = 1000;
	private var _player : Player;

	private var _completionTimer : Int;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		state = UNFINISHED;
	}

	public function completeTask(player : Player)
	{
		if(state == UNFINISHED && player.tryingToCompleteTask)
		{
			_player = player;
			new Sfx("sfx/task.wav").play();
			_completionTimer = nme.Lib.getTimer();
		}
	}

	public override function update()
	{

		if(_completionTimer > 0 && _player.canCompleteTask)
		{  
			if(nme.Lib.getTimer() > _completionTimer + durationInMs)
			{
				_completionTimer = 0;
				_sprite.play("idle_done");
				state = DONE;
			}
			else
				_sprite.play("idle_unfinished");
		}

		super.update();
	}
}