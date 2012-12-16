package worlds;

import com.haxepunk.HXP;
import com.haxepunk.tmx.TmxMap;
import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxObject;
import com.haxepunk.tmx.TmxObjectGroup;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.World;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.Sfx;
import com.haxepunk.graphics.Text;
import com.haxepunk.Entity;
import flash.geom.Point;

import entities.Player;

import entities.enemies.MovingMob;
import entities.enemies.Guardian;
import entities.enemies.Monster;

import entities.tasks.TaskEntity;
import enums.TaskState;
import entities.tasks.Tree;
import entities.tasks.Ghetto;
import entities.tasks.StripperJoint;

import entities.pows.PowEntity;
import entities.pows.PowerUp;

class GameWorld extends World {

	private var _player : Player;
	private var _map 		: TmxEntity;

	// UI 
	private var _uiEntity : Entity;
	private var _lifeTextEntity : Entity;
	private var _lifeText : Text;
	private var _completionTextEntity : Entity;
	public var _completionText : Text;
	private var _scoreTextEntity : Entity;
	private var _scoreText : Text;
	private var _totalTaskCount : Int;
	

	// Statics
	private static inline var HIT_FX = new Sfx("sfx/hit.wav");
	private static inline var POW_FX = new Sfx("sfx/pow.wav");	
	private static inline var CAMERA_OFFSET_Y : Int = -128;
	private static inline var UI_TEXT_OFFSET_Y : Int = -123;

	public function new()
	{
		super();
	}

	public override function begin()
	{
		Input.define("restart", [Key.ESCAPE]);

		addGraphic(new Backdrop("gfx/backdrop.png", true, false));
		addGraphic(new Image("gfx/finish.png"), 0, 9443, 833);

		_map = new TmxEntity("maps/map.tmx");
		_map.loadGraphic("gfx/tileset.png", ["bg", "stage"]);
		_map.loadMask("stage");
		add(_map);

		//new Sfx("music/loop.mp3").loop(0.3);

		_totalTaskCount = 0;
		initObjectsFromMap();

		_player = new Player(32, 600);		
		add(_player);

		_uiEntity = new Entity(0, 500);
		_uiEntity.graphic = new Image("gfx/ui.png");
		add(_uiEntity);

		_lifeTextEntity = new Entity(60, 500);
		_lifeText = new Text("" + _player.hp, 0, 0, 0, 0);
		_lifeText.color = 0x000000;
		_lifeTextEntity.graphic = _lifeText;
		add(_lifeTextEntity);

		_scoreTextEntity = new Entity(120, 500);
		_scoreText = new Text("SCORE: 0000000", 0, 0, 0, 0);
		_scoreText.color = 0x000000;
		_scoreTextEntity.graphic = _scoreText;
		add(_scoreTextEntity);

		_completionTextEntity = new Entity(400, 500);
		_completionText = new Text("Tasks completed: " + _player.completedTaskCount + " of " + _totalTaskCount, 0, 0, 0, 0);
		_completionText.color = 0x000000;
		_completionTextEntity.graphic = _completionText;
		add(_completionTextEntity);
	}

	public override function update()
	{
		if (Input.check("restart"))
		{
			HXP.world = new GameWorld();
		}

		// Finished the map
		if(_player.x > _map.width - 50)
		{
			HXP.world = new FinishWorld(_player.score, _player.hp, _player.completedTaskCount, _totalTaskCount);
		}

		//Center the camera on the player
		if(_player.x - HXP.width / 2 < 0)
		{
			HXP.setCamera(0, _player.y + _player.height / 2 - HXP.height / 2 + CAMERA_OFFSET_Y);
		}
		else if (_player.x + HXP.width / 2 > _map.width) 
		{
			HXP.setCamera(_map.width -  HXP.width, _player.y + _player.height / 2 - HXP.height / 2 + CAMERA_OFFSET_Y);
		}
		else
		{
			HXP.setCamera(_player.x + _player.width / 2 - HXP.width / 2, _player.y + _player.height / 2 - HXP.height / 2 + CAMERA_OFFSET_Y);
		}

		updateCollisions();

		updateUI();

		super.update();
	}

	private function initObjectsFromMap() 
	{
		var tasksGroup : TmxObjectGroup = _map.map.getObjectGroup("tasks");
		if(tasksGroup != null)
		{
			for(object in tasksGroup.objects)
			{
				var typeIdStr = object.custom.resolve("taskId");
				var typeId : Int = Std.parseInt(typeIdStr == null ? "-1" : typeIdStr);

				if(typeId == -1)
					continue;

				_totalTaskCount++;

				switch (typeId) 
				{
					case 1:
						var tree : Tree = new Tree(object.x, object.y);
						add(tree);
					case 2:
						var ghetto : Ghetto = new Ghetto(object.x, object.y);
						add(ghetto);
					case 3:
						var stripperJoint : StripperJoint = new StripperJoint(object.x, object.y);
						add(stripperJoint);
					default:
				}		
			}
		}

		var powsGroup : TmxObjectGroup = _map.map.getObjectGroup("pows");
		if(powsGroup != null)
		{
			for(object in powsGroup.objects)
			{
				var typeIdStr = object.custom.resolve("typeId");
				var typeId : Int = Std.parseInt(typeIdStr == null ? "-1" : typeIdStr);

				if(typeId == -1)
					continue;

				switch (typeId) 
				{
					case 1:
						var heart : PowerUp = new PowerUp(object.x, object.y, 1);
						add(heart);
					default:
				}
			}
		}

		var mobGroup : TmxObjectGroup = _map.map.getObjectGroup("mobs");
		if(mobGroup != null)
		{
			for(object in mobGroup.objects)
			{
				var typeIdStr = object.custom.resolve("typeId");
				var typeId : Int = Std.parseInt(typeIdStr == null ? "-1" : typeIdStr);

				if(typeId == -1)
					continue;

				switch (typeId) 
				{
					case 1:
						var guardian : Guardian = new Guardian(object.x, object.y);
						add(guardian);
					case 2:
						var monster : Monster = new Monster(object.x, object.y);
						add(monster);
					default:
				}
			}
		}
	}

	private function updateCollisions()
	{
		var mob : MovingMob = cast _player.collide('enemy', _player.x, _player.y);
		if( mob != null )
		{			
			if(!_player.isInCloakMode && _player.canBeHurt())
			{
				_player.initHurtProcess(mob.hitDamage);
				HIT_FX.play();
			}
		}

		var task : TaskEntity = cast _player.collide("task", _player.x, _player.y);
		if( task != null ) 
		{
			if(_player.isInCloakMode)
			{
				// no no no, you can't do stuff when you're in cloak mode chicken
				_player.canCompleteTask = false;
				task.resetTimer();
			}
			else
			{
				if(task.state == UNFINISHED)
					_player.canCompleteTask = true;

				if(_player.tryingToCompleteTask)
					task.completeTask(_player);
			}
		}
		else
		{
			_player.canCompleteTask = false;
			_player.tryingToCompleteTask = false;
		}

		var pow : PowEntity = cast _player.collide("pow", _player.x, _player.y);
		if( pow != null ) 
		{
			pow.handle(_player);
			POW_FX.play();
			remove(pow);
		}
	}

	private function updateUI()
	{
		var uiPositionX : Float = 0.0;
		var uiPositionY : Float = _player.y + _player.height / 2 - HXP.height / 2;

		if(_player.x - HXP.width / 2 < 0)
		{
			uiPositionX = 0;
		}
		else if (_player.x + HXP.width / 2 > _map.width) 
		{
			uiPositionX = _map.width -  HXP.width;
		}
		else
		{
			uiPositionX = _player.x + _player.width / 2 - HXP.width / 2;
		}

		_uiEntity.x = uiPositionX;
		_uiEntity.y = uiPositionY - 130;

		_lifeText.text = "" + _player.hp;
		_scoreText.text = "SCORE: " + Math.round(_player.score);
		_completionText.text = "Tasks completed: " + _player.completedTaskCount + " of " + _totalTaskCount;

		_lifeTextEntity.x = uiPositionX + 45;
		_lifeTextEntity.y = uiPositionY + UI_TEXT_OFFSET_Y;

		_scoreTextEntity.x = uiPositionX + 200;
		_scoreTextEntity.y = uiPositionY + UI_TEXT_OFFSET_Y;

		_completionTextEntity.x = uiPositionX + 400;
		_completionTextEntity.y = uiPositionY + UI_TEXT_OFFSET_Y;
	}
}