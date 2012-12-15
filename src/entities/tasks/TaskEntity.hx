
package entities.tasks;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Sfx;

import enums.TaskState;
import entities.Player;

class TaskEntity extends Entity {

	private var _sprite : Spritemap;
	public var state : TaskState;
	public var durationInMs : Int = 3000;
	private var _player : Player;

	private var _completionTimer : Int;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		_completionTimer = 0;
		state = UNFINISHED;
	}

	public function resetTimer()
	{
		_completionTimer = 0;
	}

	public function completeTask(player : Player)
	{
		if(state == UNFINISHED && _completionTimer == 0)
		{
			_completionTimer = nme.Lib.getTimer();
			_player = player;
			new Sfx("sfx/task.wav").play();
		}
	}

	public override function update()
	{
		if(_player != null)
		{
			if(!_player.tryingToCompleteTask || !_player.canCompleteTask)
				resetTimer();
		}

		if(_completionTimer > 0)
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