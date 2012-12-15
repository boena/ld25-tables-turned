
package entities.enemies;

import com.haxepunk.graphics.Spritemap;

class Guardian extends MovingMob {

	public function new(x:Float, y:Float)
	{
		super(x, y);
		
		_sprite = new Spritemap("gfx/guardian.png", 32, 32);
		_sprite.add("run", [0, 1, 2, 3], 8);
		_sprite.play("run");
		graphic = _sprite;
		
		type = 'guardian';
								
		setHitboxTo( _sprite );
		
		_moveLeft		= false;
		_moveSpeed 	= 0.75;
		
		gravity.y 		= 1.8;
		maxVelocity.x = _moveSpeed * 4;
		friction.x 		= 0.82; 
		friction.y 		= 0.99; 
	}

}