
package entities;

import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Sfx;

import enums.JumpStyle;

class Player extends PhysicsEntity {

	private var sprite:Spritemap;
	private static var jumpStyle:JumpStyle = Normal;
	private static inline var kMoveSpeed:Float = 1.6;
	private static inline var kJumpForce:Int = 20;

	public var hp : Int = 3;
	public var facingLeft = false;
	public var isInCloakMode = false;

	public var hasTouchedTheGround(default, null) : Bool;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		hasTouchedTheGround = false;

		sprite = new Spritemap("gfx/player.png", 32, 48);
		sprite.add("idle", [0]);
		sprite.add("idle_cloaked", [1]);
		sprite.add("run", [0]);
		sprite.add("run_cloaked", [1]);
		graphic = sprite;

		setHitboxTo(sprite);

		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("jump", [Key.UP, Key.W]);
		Input.define("toggle_cloak", [Key.SPACE]);

		// Set physics
		gravity.y = 1.8;
		maxVelocity.y = kJumpForce;
		maxVelocity.x = kMoveSpeed * 4;
		friction.x = 0.82; // floor friction
		friction.y = 0.99; // wall friction		
	} 

	public override function update()
	{
		acceleration.x = acceleration.y = 0;

		if( !hasTouchedTheGround && _isOnGround) 
			hasTouchedTheGround = true;

		handleInput();

		setAnimations();

		super.update();
	}

	private function handleInput()
  {
  	if (hasTouchedTheGround && Input.check("left"))
		{
			acceleration.x = -kMoveSpeed;
		}
		else if (hasTouchedTheGround && Input.check("right"))
		{
			acceleration.x = kMoveSpeed;
		}

		if(Input.pressed("toggle_cloak"))
		{
			isInCloakMode = !isInCloakMode;
		}

		if(_isOnGround && Input.pressed("jump"))
		{
			new Sfx("sfx/jump.wav").play();
			
			switch (jumpStyle)
			{
				case Normal:
					acceleration.y = -HXP.sign(gravity.y) * kJumpForce;
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
				sprite.play("idle_cloaked");
			else
				sprite.play("idle");
		}
		else
		{
			// we are moving, set animation to walk
			if(isInCloakMode)
				sprite.play("run_cloaked");
			else
				sprite.play("run");

			// this will flip our sprite based on direction
			if (velocity.x < 0) // left
			{
				sprite.flipped = true;
				facingLeft = true;
			}
			else // right
			{
				sprite.flipped = false;
				facingLeft = false;
			}
		}
	}
}