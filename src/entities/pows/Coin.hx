
package entities.pows;

import com.haxepunk.graphics.Spritemap;

class Coin extends PowEntity {

	public function new(x:Float, y:Float)
	{
		super(x, y);
	
		_sprite = new Spritemap("gfx/coin.png", 16, 16);
		_sprite.add("idle", [0]);
		_sprite.play("idle");
		graphic = _sprite;
								
		setHitboxTo( _sprite );
	}

	public override function handle(player : Player)
	{
		player.score += 10;
	}

}