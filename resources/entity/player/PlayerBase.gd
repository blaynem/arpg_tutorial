extends "res://resources/entity/EntityBase.gd"

signal player_died

@export var spell_scene: PackedScene = preload("res://resources/projectiles/Fireball.tscn")
@export var spellsManager: Node2D

@onready var animations = $AnimationPlayer
@onready var attackTimer = $AttackTimer

var lastAnimationDirection: String = "Down"
const SPELL_DAMAGE: int = 200

const SPELL_ID = "rockThrow"
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

func ranged_attack(ranged_direction: Vector2):
	if spellsManager:
		# Returns the casted spell data, or null
		var castedSpell = spellsManager.cast_spell(SPELL_ID)
		if castedSpell && spell_scene:
			# TODO: Pick correct projectile here
			var projectile = spell_scene.instantiate()
			# params needed damage dealt, damage type, projectile speed
			projectile.set_projectile_data(castedSpell.damage, castedSpell.type, castedSpell.projectileSpeed)
			get_tree().current_scene.add_child(projectile)
			projectile.global_position = self.global_position
			
			var projectile_spin = ranged_direction.angle()
			projectile.rotation = projectile_spin
			projectile.SPEED = castedSpell.projectileSpeed
			
			attackTimer.start()
