
package entities.tasks;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;

import enums.TaskState;

class TaskEntity extends Entity {

	private var _sprite : Spritemap;
	public var state : TaskState;
}