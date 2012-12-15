
package entities.tasks;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Image;
import com.haxepunk.Sfx;

import enums.TaskState;
import entities.Player;

class TaskEntity extends Entity {

	private var _sprite : Spritemap;
	public var state : TaskState;
	public var durationInMs : Int = 3000;
	private var _player : Player;
	private var _progressPlate : Image;
	private var _progressBar : Image;

	private var _completionTimer : Int;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		
		_completionTimer = 0;
		state = UNFINISHED;
		
		_progressPlate = new Image("gfx/progress.png");
		_progressPlate.alpha = 0;
		HXP.world.addGraphic(_progressPlate, 0, x, y -20);
		
		_progressBar = new Image("gfx/progspot.png");
		_progressBar.alpha = 0;
		HXP.world.addGraphic(_progressBar, 0, x + 1, y - 19);
	}

	public function resetTimer()
	{
		_completionTimer = 0;
		_progressBar.alpha = 0;
		_progressBar.scaleX = 1;
		_progressPlate.alpha = 0;
	}

	public function completeTask(player : Player)
	{
		if(state == UNFINISHED && _completionTimer == 0)
		{
			_completionTimer = nme.Lib.getTimer();
			_player = player;
			
			_progressBar.alpha = 1;
			_progressPlate.alpha = 1;

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
			var completionProgress : Float = (nme.Lib.getTimer() - _completionTimer) / durationInMs * 60.0;
			trace(nme.Lib.getTimer() - _completionTimer / durationInMs);
			if(completionProgress > 58)
				completionProgress = 58;

			_progressBar.scaleX = completionProgress;

			if(nme.Lib.getTimer() > _completionTimer + durationInMs)
			{
				_completionTimer = 0;
				_sprite.play("idle_done");
				state = DONE;
				_player.completedTaskCount++;

				_progressBar.alpha = 0;
				_progressPlate.alpha = 0;
			}
			else
				_sprite.play("idle_unfinished");
		}

		super.update();
		
	}
}