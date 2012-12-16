
package worlds;

import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.World;
import com.haxepunk.graphics.Image;
import com.haxepunk.Sfx;

class MenuWorld extends World {


	public function new()
	{
		super();
	}

	public override function begin()
	{
		addGraphic(new Image("gfx/startscreen.png"));
	}

	public override function update()
	{
		if(Input.check(Key.ENTER))
		{
			HXP.world = new GameWorld();
		}
	}

}