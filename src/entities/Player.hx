
package entities;

import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Sfx;

import enums.JumpStyle;

class Player extends PhysicsEntity {

	private var _sprite : Spritemap;
	private var _hurtTimer : Int;

	private static inline var JUMP_STYLE : JumpStyle 	= Normal;
	private static inline var MOVE_SPEED : Float 			= 1.6;
	private static inline var JUMP_FORCE : Int 				= 20;
	private static inline var HURT_DELAY_MS : Int 		= 3000;

	public var hp : Int 			= 3;
	public var facingLeft 		= false;
	public var isInCloakMode 	= false;

	public var hasTouchedTheGround(default, null) : Bool;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		hasTouchedTheGround = false;

		_sprite = new Spritemap("gfx/player.png", 32, 48);
		_sprite.add("idle", [0]);
		_sprite.add("idle_cloaked", [1]);
		_sprite.add("run", [0]);
		_sprite.add("run_cloaked", [1]);
		graphic = _sprite;

		setHitboxTo(_sprite);

		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("jump", [Key.UP, Key.W]);
		Input.define("toggle_cloak", [Key.SPACE]);

		// Set physics
		gravity.y 		= 1.8;
		maxVelocity.y = JUMP_FORCE;
		maxVelocity.x = MOVE_SPEED * 4;
		friction.x 		= 0.82;
		friction.y 		= 0.99; 	
	} 

	public override function update()
	{
		acceleration.x = acceleration.y = 0;

		if( !hasTouchedTheGround && _isOnGround) 
			hasTouchedTheGround = true;

		handleInput();
		setAnimations();

		if(_hurtTimer > 0)
		{  
			if(nme.Lib.getTimer() > _hurtTimer + HURT_DELAY_MS)
			{
				_hurtTimer = 0;
				_sprite.alpha = 1;
			}
			else
				_sprite.alpha = 0.2;
		}

		super.update();
	}

	private function handleInput()
  {
  	if (hasTouchedTheGround && Input.check("left"))
		{
			acceleration.x = -MOVE_SPEED;
		}
		else if (hasTouchedTheGround && Input.check("right"))
		{
			acceleration.x = MOVE_SPEED;
		}

		if(Input.pressed("toggle_cloak"))
		{
			isInCloakMode = !isInCloakMode;
		}

		if(_isOnGround && Input.pressed("jump"))
		{
			new Sfx("sfx/jump.wav").play();

			switch (JUMP_STYLE)
			{
				case Normal:
					acceleration.y = -HXP.sign(gravity.y) * JUMP_FORCE;
				case Gravity:
					gravity.y = -gravity.y;
				case Disable:
			}
		}
  }

  private function setAnimations()
	{
		if (velocity.x == 0)
		{
			// we are stopped, set animation to idle
			if(isInCloakMode)
				_sprite.play("idle_cloaked");
			else
				_sprite.play("idle");
		}
		else
		{
			// we are moving, set animation to walk
			if(isInCloakMode)
				_sprite.play("run_cloaked");
			else
				_sprite.play("run");

			// this will flip our _sprite based on direction
			if (velocity.x < 0) // left
			{
				_sprite.flipped = true;
				facingLeft = true;
			}
			else // right
			{
				_sprite.flipped = false;
				facingLeft = false;
			}
		}
	}

	public function initHurtProcess()
	{
		_hurtTimer = nme.Lib.getTimer();
	}
	
	public function canBeHurt():Bool
	{
		return _hurtTimer == 0;
	}
}