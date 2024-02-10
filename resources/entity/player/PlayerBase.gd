extends "res://resources/entity/EntityBase.gd"

signal player_died

# Options for spells: fireball , iceSpike, rockThrow, todo: energyBall
const SPELL_ID = "rockThrow"
#@export var spell_scene: PackedScene = preload("res://resources/projectiles/IceSpikes.tscn")
#@export var spell_scene: PackedScene = preload("res://resources/projectiles/Fireball.tscn")
@export var spell_scene: PackedScene = preload("res://resources/projectiles/RockThrow.tscn")

@export var spellsManager: Node2D

@onready var animations = $AnimationPlayer
@onready var attackTimer = $AttackTimer

var lastAnimationDirection: String = "Down"
const SPELL_DAMAGE: int = 0

func _ready():
	if spellsManager:
		spellsManager.add_player_spell(SPELL_ID)

func _physics_process(delta):
	handleInput()
	updateAnimation()
	move()
	
func die():
	super.die()
	player_died.emit()
	
func updateAnimation():
	if velocity.length() == 0:
		animations.stop()
	else:
		var direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
		
		animations.play("walk" + direction)
		lastAnimationDirection = direction
		
func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right","ui_up","ui_down")
	velocity = moveDirection * SPEED
	
	if Input.is_action_just_pressed("action_attack") and attackTimer.is_stopped():
		var ranged_direction = self.global_position.direction_to(get_global_mouse_position())
		ranged_attack(ranged_direction)

var number_of_icicles = 16
var radius = 2  # Distance from the character to the icicles
func create_aoe_ice_spikes(castedSpell):
	var angle_step = 2 * PI / number_of_icicles
	var current_angle = 0
	var spell_cast_position = global_position  # Capture the character's current position

	for i in range(number_of_icicles):
		var icicle_instance = spell_scene.instantiate()
		icicle_instance.set_projectile_data(castedSpell)

		# Instead of adding icicles as children of the character,
		# add them to a fixed node in the scene, like the "World" node or an "Effects" node.
		var world = get_parent().get_parent()
		world.add_child(icicle_instance)  # Adjust the path to your world or stationary node

		# Set the icicle's global position to the captured spell cast position
		icicle_instance.global_position = spell_cast_position + Vector2(cos(current_angle), sin(current_angle)) * radius

		# Optional: Rotate icicles to face outwards or towards a specific point
		icicle_instance.rotation = current_angle
		current_angle += angle_step


func ranged_attack(ranged_direction: Vector2):
	if spellsManager:
		# Returns the casted spell data, or null
		var castedSpell = spellsManager.cast_spell(SPELL_ID)
		if SPELL_ID == "iceSpike":
			if castedSpell:
				create_aoe_ice_spikes(castedSpell)
		else:
			if castedSpell && spell_scene:
				# TODO: Pick correct projectile here
				var projectile = spell_scene.instantiate()
				projectile.set_projectile_data(castedSpell)
				get_tree().current_scene.add_child(projectile)
				projectile.global_position = self.global_position
				
				var projectile_spin = ranged_direction.angle()
				projectile.rotation = projectile_spin
				
				attackTimer.start()
