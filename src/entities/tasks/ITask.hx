
package entities.tasks;

import enums.TaskState;

interface ITask {

	var durationInMs : Int;
	var state : TaskState;
	
}