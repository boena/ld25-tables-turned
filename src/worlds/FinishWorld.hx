
package worlds;

import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.World;
import com.haxepunk.graphics.Image;
import com.haxepunk.Sfx;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;

class FinishWorld extends World {

	private var _score : Float;
	private var _livesLeft : Int;
	private var _totalScore : Float;
	private var _tasksCompleted : Int;
	private var _totalTasks : Int;

	public function new(score, livesLeft, tasksCompleted, totalTasks)
	{
		_tasksCompleted = tasksCompleted;
		_totalTasks = totalTasks;
		_score = Math.round(score);
		_livesLeft = livesLeft;
		_totalScore = Math.round(score) + livesLeft * 1000;
		super();
	}

	public override function begin()
	{
		addGraphic(new Image("gfx/finishscreen.png"));

		var descriptionEntity = new Entity(132 , 300);				
		var descriptionText = new Text("Score:\nLife bonus:\nTask bonus:\n\nTotal score:\nTasks completed:", 0, 0, 0, 0);		
		descriptionEntity.graphic = descriptionText;
		add(descriptionEntity);

		var numbersEntity = new Entity(332 , 300);				
		var numbersText = new Text(_score + "\n" + _livesLeft + " * 1000 = " + _livesLeft * 1000 + "\n" + _tasksCompleted + " * 200 = " + _tasksCompleted * 200 + "\n\n" + _totalScore + "\n" + _tasksCompleted + " of " + _totalTasks, 0, 0, 0, 0);		
		numbersEntity.graphic = numbersText;
		add(numbersEntity);
	}

	public override function update()
	{
		if(Input.check(Key.ESCAPE))
		{
			HXP.world = new GameWorld();
		}
	}

}