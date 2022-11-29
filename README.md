# Demo Godot4 : Generic character state machine

## Description
This project generate a state machine based character 3D controller from a resource or a .json file. The project also contain a input remapping system.  

The project comes with 8 implemented states and 2 examples (1 file and 1 resource) for a player character controller. 

The project is developed on Godot 4 beta 4

---
---

## Disclaimer
- The project is intended as a demo for how to implement this system. Without further implementation, the use cases are limited.
- The project use strings to identify states. It is susceptible to typos.
- The  project use an input buffer from an other project. 
- The naming nomenclature is closer to C# than to python

---
---

## Features 
The project contain the following features :

- Input mapping system
- Input buffer system
- 2 camera modes
- State machine generation system
- Examples (8 states, 2 state machine)

---
---

## How to use

For the state machine to work, 2 condition need to be met:

- The character 3D that will be controlled need to inherit from **Character3DEntity** and match the minimal structure for the entity (bodyPivot and InputBuffer).
- The **GenericCharacter3DStateManager** need to have either the resource or the file describing the state machine.

---

### Character3DEntity
The Character 3D on which you want to apply the state machine **need to inherit from this class**. The class contain references to needed nodes. The references to those node must be assigned in the _ready() function.

The node needed are:

- The inputBufferManager is a reference to a **InputBufferManager** that contain the input buffer for the character 3D
- The bodyPivot is a reference to a **Node3D** the is the parent to all the meshed for the entity. This node is used to rotate the meshes according to the movement of the entity.
- The stateManager is a reference to the **GenericCharacter3DStateManager** that control the **Character3DEntity**. in the project this reference is used only for initialization, but it can be used to force a state change from outside the state machine.

The Init() function in **Character3DEntity** call the initialization of the state machine. The function should be either called by the inherited class _ready() function or its content be replicated in the _ready() function of the inherited class

The MeshToRotate() return the boolean that determine if the mesh should be rotated according to the movement direction.

---

### InputBuffer
The input buffer is an array of **BufferInputDescriptor** where each element has the following information :

- the action associated with the input
- the timestamp of when the input was pressed
- the timestamp of when the input was released
- if the input is still pressed

The **InputBufferManager** update those input descriptors and remove those that expires. It is the responsibility of the **Character3DEntity** to fill the buffer.

---

### State machine basic
Each state contain the logic associated with the state and the information regarding the next possible states.

Each state inherit from **BaseCharacter3DState** and implement 4 core function:

- Enter() is called when entering the state.
- Exit() is called when exiting the state.
- CheckState() is called each frame to check the condition for a state change. In the demo, only the base class implement this function because the implementation is the same for all states. If CheckState() return "", it means no changes. Else, the function return the name of the next state.
- Process(delta) is called each frame to apply the state logic on the **Active** entity.

Some states implement _process(delta) when some process should be taken care of even when the state is not the active one 

*Important*: 

The order of calls each frame is as follow
1. CheckState()
2. if the state need to change, Exit() the previous state and Enter() the new state
3. Process(delta)

Also, the CheckState() check the **Character3DStateChangeValidator** in the order in which they are in the array. The first state change that has its condition fulfilled is the one that will be used.

---

### State machine data structure
Each state use the data contained in the associated stateResource. When using a **Character3DStateMachineResource** as a source for the state machine, those state resource are declared in the **Character3DStateMachineResource**. When using a file as a sources, the stateResources are generated from the file then used by the state machine.

Each state has some parameters and a list of **Character3DStateChangeValidator**. A **Character3DStateChangeValidator** represent a possible state change. It contains the name of the next state and the condition on which the state change occurs. The logic operators used inherit from **BaseCharacter3DCondition**

---

### List of implemented states

The base json format is as follow
```
{
    "stateName": state declaration,
    ...
}
```
Where each state has a line.
"stateName" is the key that identify the state and state declaration is one of the json object describe below

> Base state

Parent state, doesn't do anything except wait for a state change

Field (present in all states): 
- stateName : name of the state (use a key to identify it)
- meshRotationSpeed : speed in deg/s at which the mesh of the entity rotate in this state
- nextStateConditionList : List of **Character3DStateChangeValidator** that represent the possibles next state.

*This state cannot be instantiated from json*

> Idle

This state does nothing except wait for a state change

No state specific fields

Json declaration 
```
{
    "stateType": "idle",
    "meshRotationSpeed": float,
    "conditions": []
}
```
"stateType" define what type of state it is. 
"conditions" correspond to the nexStateConditionList 

> Walk Velocity

This state move the entity horizontally with instantaneous speed. If the entity is on the ground, the entity will stick to the ground.

Field:
- speed : speed applied to the entity

Json declaration
```
{
    "stateType": "walkVelocity",
    "meshRotationSpeed": float,
    "speed": float,
    "conditions": []
}
```

> Walk Acceleration

This state move the entity horizontally by applying acceleration. If the entity is on the ground, the entity will stick to the ground.

Field:
- maxSpeed : maximum speed the entity can have. Warning : if the entity enter this state with a speed higher than the limit, the speed will be instantly reduced to the max speed.
- acceleration : acceleration applied to the entity when an input is pressed.
- friction : friction coefficient apply to the entity.

Json declaration
```
{
    "stateType": "walkAcceleration",
    "meshRotationSpeed": float,
    "maxSpeed": float,
    "acceleration": float,
    "friction": float,
    "conditions": []
}
```

> Air Velocity

State that apply gravity to the entity and move the entity horizontally with instantaneous speed.

Field:
- horizontalMovementSpeed : speed apply to the entity for horizontal movement.
- gravityAcceleration : acceleration of the gravity (a positive value mean that the entity fall)


Json declaration
```
{
    "stateType": "airVelocity",
    "meshRotationSpeed": float,
    "horizontalMovementSpeed": float,
    "gravityAcceleration": float,
    "conditions": []
}
```

> Air Acceleration

State that apply gravity to the entity and move the entity horizontally by applying acceleration.

Field:
- horizontalMaxSpeed : maximum horizontal speed the entity can have. Warning : if the entity enter this state with a speed higher than the limit, the speed will be instantly reduced to the max speed.
- fallMaxSpeed : maximum down speed the entity can have.
- horizontalAcceleration : acceleration applied to the entity when an input is pressed.
- gravityAcceleration : acceleration of the gravity (a positive value mean that the entity fall).
- friction : friction coefficient apply to the entity.

Json declaration
```
{
    "stateType": "airAcceleration",
    "meshRotationSpeed": float,
    "horizontalMaxSpeed": float,
    "fallMaxSpeed": float,
    "horizontalAcceleration": float,
    "gravityAcceleration": float,
    "friction": float,
    "conditions": []
}
```

> Jump Velocity

State that apply an initial velocity, then act like Air Velocity. The state can restrict the jump base on a jump count and a jump cooldown.

Field:
- jumpImpulse : Vector3 representing the initial jump velocity.
- jumpCount : count of how many jump the entity can have between resets.
- jumpCooldown : cooldown between jumps.
- resetJumpCountOnFloor : determine if the jump count should be fully replenished when touching the ground.
- resetJumpCountOnWall : determine if the jump count should be fully replenished when touching a wall.
- resetJumpCountOnCooldown : determine if the jump count should be incremented by 1 each time a cooldown duration pass (capped by jumpCount).
- variableJump : determine if the jump should be variable. A variable jump cut the vertical speed if it is above a threshold when the state is exited.
- variableJumpFactor : define the threshold as a fraction of the vertical speed of the impulse. (a factor of 2 mean that the threshold is 1/2 the impulse) 
- horizontalMovementSpeed : speed apply to the entity for horizontal movement.
- gravityAcceleration : acceleration of the gravity (a positive value mean that the entity fall)

Json declaration
```
{
    "stateType": "jumpVelocity",
    "meshRotationSpeed": float,
    "jumpImpulse":{
        "x": float,
        "y": float,
        "z": float
    },
    "jumpCount": int,
    "jumpCooldown": float,
    "resetJumpCountOnFloor": bool,
    "resetJumpCountOnWall": bool,
    "resetJumpCountOnCooldown": bool,
    "variableJump": bool,
    "variableJumpFactor": float,
    "horizontalMaxSpeed": float,
    "fallMaxSpeed": float,
    "horizontalAcceleration": float,
    "gravityAcceleration": float,
    "friction": float,
    "conditions": []
}
```

> Jump Acceleration

State that apply an initial velocity, then act like Air Acceleration. The state can restrict the jump base on a jump count and a jump cooldown.

Field:
- jumpImpulse : Vector3 representing the jump velocity added when entering the state.
- jumpCount : count of how many jump the entity can have between resets.
- jumpCooldown : cooldown between jumps.
- resetJumpCountOnFloor : determine if the jump count should be fully replenished when touching the ground.
- resetJumpCountOnWall : determine if the jump count should be fully replenished when touching a wall.
- resetJumpCountOnCooldown : determine if the jump count should be incremented by 1 each time a cooldown duration pass (capped by jumpCount).
- variableJump : determine if the jump should be variable. A variable jump cut the vertical speed if it is above a threshold when the state is exited.
- variableJumpFactor : define the threshold as a fraction of the vertical speed of the impulse. (a factor of 2 mean that the threshold is 1/2 the impulse) 
- horizontalMaxSpeed : maximum horizontal speed the entity can have. Warning : if the entity enter this state with a speed higher than the limit, the speed will be instantly reduced to the max speed.
- fallMaxSpeed : maximum down speed the entity can have.
- horizontalAcceleration : acceleration applied to the entity when an input is pressed.
- gravityAcceleration : acceleration of the gravity (a positive value mean that the entity fall).
- friction : friction coefficient apply to the entity.

Json declaration
```
{
    "stateType": "jumpAcceleration",
    "meshRotationSpeed": float,
    "jumpImpulse":{
        "x": float,
        "y": float,
        "z": float
    },
    "jumpCount": int,
    "jumpCooldown": float,
    "resetJumpCountOnFloor": bool,
    "resetJumpCountOnWall": bool,
    "resetJumpCountOnCooldown": bool,
    "variableJump": bool,
    "variableJumpFactor": float,
    "horizontalMovementSpeed": float,
    "gravityAcceleration": float,
    "conditions": []
}
```

> Climb

State that change the horizontal control to a vertical one (forward move the entity up) and make the entity face the wall.
Note the lateral movement are relative to the mesh orientation, not the entity orientation.

Field:
- verticalClimbSpeed : speed at which the entity move up and down.
- horizontalClimbSpeed : speed at which the entity move laterally.

Json declaration 
```
{
    "stateType": "climb",
    "meshRotationSpeed": float,
    "verticalClimbSpeed": float,
    "horizontalClimbSpeed": float,
    "conditions": []
}
```

---

### List of implemented conditions

Each condition has as a root a **Character3DStateChangeValidator**.

Field:
- nextStateName : key of the next state
- condition : condition tree

Json declaration
```
{
    "nextStateName": string,
    "condition": condition
}
```

Where condition can be any of the following

> Base Condition

Parent condition, return false by default(ie. the condition is never fulfilled)

*This state cannot be instantiated by json*

> True

Condition that is always true

Json declaration
```
{
    "conditionType": "true"
}
```

> Not

Condition that inverse the child condition

Field
- condition : condition to inverse

Json declaration
```
{
    "conditionType": "not",
    "condition": condition
}
```

> And

Condition that return true if the 2 child conditions are true

Field
- firstCondition 
- secondCondition

Json declaration
```
{
    "conditionType": "and",
    "firstCondition": condition,
    "secondCondition": condition
}
```

> Or

Condition that return true if any of the 2 child conditions is true

Field
- firstCondition 
- secondCondition

Json declaration
```
{
    "conditionType": "or",
    "firstCondition": condition,
    "secondCondition": condition
}
```

> On Floor

Return true if the entity is on the floor

Json declaration
```
{
    "conditionType": "onFloor"
}
```

> On Wall

Return true if the entity is on a wall

Json declaration
```
{
    "conditionType": "onWall"
}
```
> Input Pressed

Return true if a specific input is pressed. The condition add the possibility to check if it is a double tap and/or remove l'input from the buffer after detection

Field:
- actionName : name of the action associated with the input
- doubleTap : determine if the input should be a double tap
- doubleTapTimeFrame : maximum delay in ms between two tap to be considered as double tap
- removeInput : determine if the input is to be removed after detection

Json declaration 
```
{
    "conditionType": "inputPressed",
    "actionName": string,
    "doubleTap": bool,
    "doubleTapTimeFrame": float,
    "removeInput": bool
}
```

> Input Set Pressed

Return true if any input in a list is pressed

Field
- actionList: list of action name associated to the target inputs

Json declaration 
```
{
    "conditionType": "inputSetPressed",
    "actionList": [string]
}
```

> Max Speed

Return true if the weighted speed of the entity is lower than a threshold speed

Field:
- speedLimit : speed threshold
- axeWeight : proportion of the speed on each axe that count toward the comparison. A 1 mean that the speed on this axes is fully taken into account, a 0 mean that the speed on the axe is ignored. The axis are expressed in the local space of the entity.

Json declaration 
```
{
    "conditionType": "maxSpeed",
    "speedLimit": float,
    "axeWeight": {
        "x": float,
        "y": float,
        "z": float
    }
}
```