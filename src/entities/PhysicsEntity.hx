package entities;

import flash.geom.Point;
import com.haxepunk.HXP;
import com.haxepunk.Entity;

class PhysicsEntity extends Entity
{
	// Properties
	public var velocity 		: Point;
	public var acceleration :	Point;
	public var friction 		: Point;
	public var maxVelocity 	: Point;
	public var gravity 			:	Point;

	private var _isOnGround:Bool;	

	public function new(x:Float, y:Float)
	{
		super(x, y);
		_isOnGround 	= false;

		velocity     = new Point();
		acceleration = new Point();
		friction     = new Point();
		maxVelocity  = new Point();
		gravity      = new Point();
	}

	public var onGround(getOnGround, null): Bool;
	private function getOnGround():Bool { return _isOnGround; }

	override public function update()
	{
		// Apply acceleration and velocity
		velocity.x += acceleration.x;
		velocity.y += acceleration.y;

		applyVelocity();
		applyGravity();
		
		checkMaxVelocity();
		
		super.update();
	}

	public function applyGravity()
	{
		velocity.x += gravity.x;
		velocity.y += gravity.y;
	}

	private function checkMaxVelocity()
	{
		if (maxVelocity.x > 0 && Math.abs(velocity.x) > maxVelocity.x)
		{
			velocity.x = maxVelocity.x * HXP.sign(velocity.x);
		}

		if (maxVelocity.y > 0 && Math.abs(velocity.y) > maxVelocity.y)
		{
			velocity.y = maxVelocity.y * HXP.sign(velocity.y);
		}
	}

	public override function moveCollideY(e:Entity)
	{
		if (velocity.y * HXP.sign(gravity.y) > 0)
		{
			_isOnGround = true;
		}

		velocity.y = 0;
		
		velocity.x *= friction.x;
		if (Math.abs(velocity.x) < 0.5) velocity.x = 0;
	}

	public override function moveCollideX(e:Entity)
	{
		velocity.x = 0;
		
		velocity.y *= friction.y;
		if (Math.abs(velocity.y) < 1) velocity.y = 0;
	}

	private function applyVelocity()
	{
		_isOnGround = false;
		moveBy(velocity.x, velocity.y, "solid", true);
	}
}
