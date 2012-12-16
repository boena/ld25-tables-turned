
package entities.enemies;

import com.haxepunk.graphics.Spritemap;

class Monster extends MovingMob {

	public function new(x:Float, y:Float)
	{
		super(x, y);
		
		_sprite = new Spritemap("gfx/monster.png", 64, 64);
		_sprite.add("run", [0, 1, 2], 8);
		_sprite.play("run");
		graphic = _sprite;
		
		type = 'enemy';
		hitDamage = 6;
								
		setHitboxTo( _sprite );
		
		_moveLeft		= false;
		_moveSpeed 	= 0.75;
		
		gravity.y 		= 1.8;
		maxVelocity.x = _moveSpeed * 4;
		friction.x 		= 0.82; 
		friction.y 		= 0.99; 
	}

}