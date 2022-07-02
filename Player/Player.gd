extends KinematicBody2D

export var ACCEL = 500
export var MAX_SPEED = 80
export var FRICTION = 500
export var ROLL_SPEED = 150

enum {
	MOVE,
	ATTACK,
	ROLL
}

var state = MOVE
var velocity = Vector2.ZERO
var rollVector = Vector2.DOWN
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxRotate/Hitbox
onready var hurtbox = $Hurtbox

func disableHitbox():
	$HitboxRotate/Hitbox/CollisionShape2D.set_deferred('disabled', true)

func enableHitbox():
	$HitboxRotate/Hitbox/CollisionShape2D.set_deferred('disabled', false)

func _ready():
	stats.connect("noHealth", self, "queue_free")
	animationTree.active = true
	swordHitbox.knockbackVector = rollVector
	disableHitbox()

func _physics_process(delta):
	match state:
		MOVE:
			moveState(delta)
		ATTACK:
			attackState(delta)
		ROLL:
			rollState(delta)


func moveState(delta):
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	inputVector = inputVector.normalized()
	#normalizing inputvector to stop issue with moving faster at diagonals
	
	if inputVector != Vector2.ZERO:
		rollVector = inputVector
		swordHitbox.knockbackVector = inputVector
		animationTree.set("parameters/Idle/blend_position", inputVector)
		animationTree.set("parameters/Run/blend_position", inputVector)
		animationTree.set("parameters/Attack/blend_position", inputVector)
		animationTree.set("parameters/Roll/blend_position", inputVector)
		#sets blend position of animations in animationTreeeto be equal to inputVector
		#so character will face "right way"
		
		animationState.travel("Run")
		velocity = velocity.move_toward(inputVector * MAX_SPEED, ACCEL * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("player_attack"):
		state = ATTACK
	
	if Input.is_action_just_pressed("player_roll") and inputVector != Vector2.ZERO:
		#state = ROLL
		#very fucky lol... sprite falls under BG even with ysort. Maybe a dash would make more sense
		#TODO: find or make dash sprite? 
		pass

func move():
	velocity = move_and_slide(velocity)

func attackState(delta):
	enableHitbox()
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	

func endAttack():
	disableHitbox()
	state = MOVE
	#called by animation player when attack animation ends

func rollState(delta):
	animationState.travel("Roll")
	move()

func endRoll():
	state = MOVE
	#called by animation player when roll animation ends.


func _on_Hurtbox_area_entered(area):
	stats.health -= 1
	hurtbox.startInvinc(0.5)
	hurtbox.create_hit_effect(area)
