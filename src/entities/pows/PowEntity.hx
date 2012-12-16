
package entities.pows;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;

class PowEntity extends Entity {

	private var _sprite : Spritemap;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		
		type = 'pow';
	}

	// Should be implemented in sub class
	public function handle(player : Player)
	{

	}
}