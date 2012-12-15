package worlds;

import com.haxepunk.HXP;
import com.haxepunk.tmx.TmxMap;
import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxObject;
import com.haxepunk.tmx.TmxObjectGroup;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import com.haxepunk.World;
import com.haxepunk.graphics.Image;
import com.haxepunk.Sfx;
import com.haxepunk.tmx.TmxEntity;
import flash.geom.Point;

import entities.Player;
import entities.enemies.Guardian;

class GameWorld extends World {

	private var _player : Player;
	private var _map 		: TmxEntity;

	private static inline var _cameraOffsetY : Int = -128;

	public function new()
	{
		super();
	}

	public override function begin()
	{
		Input.define("restart", [Key.ESCAPE]);

		_map = new TmxEntity("maps/map.tmx");
		_map.loadGraphic("gfx/tileset.png", ["bg", "stage"]);
		_map.loadMask("stage");
		add(_map);

		_player = new Player(32, 600);		
		add(_player);

		initObjectsFromMap();
	}

	public override function update()
	{
		if (Input.check("restart"))
		{
			HXP.world = new GameWorld();
		}

		//Center the camera on the player
		if(_player.x - HXP.width / 2 < 0)
		{
			HXP.setCamera(0, _player.y + _player.height / 2 - HXP.height / 2 + _cameraOffsetY);
		}
		else if (_player.x + HXP.width / 2 > _map.width) 
		{
			HXP.setCamera(_map.width -  HXP.width, _player.y + _player.height / 2 - HXP.height / 2 + _cameraOffsetY);
		}
		else
		{
			HXP.setCamera(_player.x + _player.width / 2 - HXP.width / 2, _player.y + _player.height / 2 - HXP.height / 2 + _cameraOffsetY);
		}

		updateMobCollisions();
		super.update();
	}

	private function initObjectsFromMap() 
	{
		var mobGroup : TmxObjectGroup = _map.map.getObjectGroup("mobs");
		if(mobGroup != null)
		{
			for(object in mobGroup.objects)
			{
				var typeIdStr = object.custom.resolve("typeId");
				var typeId : Int = Std.parseInt(typeIdStr == null ? "-1" : typeIdStr);

				if(typeId == -1)
				{
					trace("Type id of mob is null");
					continue;
				}

				switch (typeId) 
				{
					case 1:
						trace("adding mob with type id 1 - guardian");
						var guardian : Guardian = new Guardian(object.x, object.y);
						add(guardian);
						break;
					default:
				}
			}
		}
	}

	private function updateMobCollisions()
	{
		var guardian : Guardian = cast _player.collide('guardian', _player.x, _player.y);
		if( guardian != null )
		{			
			new Sfx("sfx/hit.wav").play();
		}
	}
}