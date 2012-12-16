
package entities.pows;

import com.haxepunk.graphics.Spritemap;

class PowerUp extends PowEntity {
	private var _hpBoost : Int = 1;
	public function new(x:Float, y:Float, hpBoost:Int)
	{
		super(x, y);
	
		_sprite = new Spritemap("gfx/heart.png", 32, 32);
		_sprite.add("idle", [0]);
		_sprite.play("idle");
		graphic = _sprite;
		
		_hpBoost = hpBoost;
								
		setHitboxTo( _sprite );
	}

	public override function handle(player : Player)
	{
		player.hp += _hpBoost;
	}

}