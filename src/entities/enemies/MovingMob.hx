
package entities.enemies;
 
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Entity;

import entities.PhysicsEntity;

class MovingMob extends PhysicsEntity {

	private var _sprite    : Spritemap;
	private var _moveLeft  : Bool;
	private var _moveSpeed : Float 	= 0.85;
	
	public var hitDamage 	 : Int 		= 1;

	public override function update()
	{
		acceleration.x = acceleration.y = 0;

		if(_moveLeft)
			acceleration.x = -_moveSpeed;
		else 
			acceleration.x = _moveSpeed;
				
		super.update();

		// Always face the direction we were last heading
		if (velocity.x < 0)
			_sprite.flipped = true; // left
		else if (velocity.x > 0)
			_sprite.flipped = false; // right
	}
	
	public override function moveCollideX(e:Entity)
	{
		acceleration.x = 0;
		_moveLeft = !_moveLeft;
	}

}