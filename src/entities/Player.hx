
package entities;

import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Sfx;

import enums.JumpStyle;
import worlds.GameWorld;

class Player extends PhysicsEntity {

	private var _sprite : Spritemap;
	private var _hurtTimer : Int;

	private static inline var JUMP_STYLE : JumpStyle 	= NORMAL;
	private static inline var MOVE_SPEED : Float 			= 1.6;
	private static inline var JUMP_FORCE : Int 				= 20;
	private static inline var HURT_DELAY_MS : Int 		= 3000;

	public var hp : Int 										= 10;
	public var facingLeft : Bool						= false;
	public var isInCloakMode : Bool 				= false;
	public var canCompleteTask : Bool 			= false;
	public var tryingToCompleteTask : Bool 	= false;

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
		_sprite.add("cloaking", [2, 3], 8, false);
		graphic = _sprite;

		setHitboxTo(_sprite);

		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("jump", [Key.UP, Key.W]);
		Input.define("toggle_cloak", [Key.SPACE]);
		Input.define("use", [Key.E]);

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
			_sprite.play("cloaking", true);
		}

		if(_isOnGround && !isInCloakMode && canCompleteTask && Input.pressed("use"))
		{
			tryingToCompleteTask = true;
		}

		if(_isOnGround && Input.pressed("jump"))
		{
			new Sfx("sfx/jump.wav").play();

			switch (JUMP_STYLE)
			{
				case NORMAL:
					acceleration.y = -HXP.sign(gravity.y) * JUMP_FORCE;
				case GRAVITY:
					gravity.y = -gravity.y;
				case DISABLED:
			}
		}
  }

  private function setAnimations()
	{
		if(_sprite.currentAnim == "cloaking")
		{
			if(!_sprite.complete)
				return;
		}

		if (velocity.x == 0)
		{
			if(isInCloakMode)
				_sprite.play("idle_cloaked");
			else
				_sprite.play("idle");
		}
		else
		{
			if(isInCloakMode)
				_sprite.play("run_cloaked");
			else
				_sprite.play("run");

			if (velocity.x < 0) 
			{
				_sprite.flipped = true;
				facingLeft = true;
			}
			else 
			{
				_sprite.flipped = false;
				facingLeft = false;
			}
		}
	}

	public function initHurtProcess(damage:Int)
	{
		// Init hurt timer
		_hurtTimer = nme.Lib.getTimer();
		
		// Take away life
		hp = hp - damage;
		
		// If we don't have any HP left. It's game over son.
		if(hp <= 0)
		{
			// TODO: Game Over World
			HXP.world = new GameWorld();
		}
	}
	
	public function canBeHurt():Bool
	{
		return _hurtTimer == 0;
	}
}