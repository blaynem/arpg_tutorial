extends CharacterBody2D

@export var speed = 20
@export var limit = 1
@export var endPoint: Marker2D

@onready var animations = $AnimationPlayer

var startPosition
var endPosition

func _ready():
	startPosition = position
# This is 3 times the height of the tile size, so 16 size! wow size!
	endPosition = endPoint.global_position

func changeDirection():
	# Note we have to have a temp var otherwise it will end up overwriting and becoming same
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd

func updateAnimation():
	if velocity.length() == 0:
		animations.stop()
	else:
		var direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
		
		animations.play("walk" + direction)

func updateVelocity():
	var moveDirection = (endPosition - position)
	if moveDirection.length() < limit:
		changeDirection()
		
	velocity = moveDirection.normalized() * speed
	
func _physics_process(delta):
	updateVelocity()
	updateAnimation()
	move_and_slide()
