extends CharacterBody2D

signal hp_max_changed(new_hp_max)
signal hp_changed(new_hp)
signal died

const INDICATOR_DAMAGE = preload("res://resources/ui/damage_indicator.tscn")

@export var hp_max: int = 100 : set = _set_hp_max
@export var hp: int = hp_max : set = _set_hp, get = _get_hp
@export var defense: int = 0
@export var SPEED: int = 75
@export var display_name: String = "Placeholder"

@export var EFFECT_HIT: PackedScene = null
@export var EFFECT_DIED: PackedScene = null

@export var canBeKnockedBack: bool = true
@export var knockback_modifier: float = 0.1

@onready var collisionShape: CollisionShape2D = $CollisionShape
@onready var animationPlayer: AnimationPlayer = $AnimationPldayer
@onready var hurtbox: Area2D = $HurtBox
@onready var healthbar: TextureProgressBar  = $EntityHealthBar
@onready var nameBar: Label = $NameBar

func _ready():
	if healthbar:
			healthbar.value = hp
			healthbar.max_value = hp_max
	if nameBar:
		nameBar.text = display_name

func _physics_process(delta):
	move()

func move():
	move_and_slide()

func die():
	spawn_effect(EFFECT_DIED)
	queue_free()

func _get_hp():
	return hp

func _set_hp(newHp: int):
	if newHp != hp:
		hp = clamp(newHp, 0 , hp_max)
		hp_changed.emit(hp)
		if healthbar:
			healthbar.animate_hp_change(hp)
		if hp == 0:
			died.emit()

func _set_hp_max(newMaxHp: int):
	if newMaxHp != hp_max:
		hp_max = max(0, newMaxHp)
		hp_max_changed.emit(hp_max)
		if healthbar:
			healthbar.max_value = hp_max

func receive_knockback(damage_source_pos: Vector2, received_damage:int):
	if canBeKnockedBack:
		var dir = damage_source_pos.direction_to((self.global_position))
		var knock_strength = received_damage * knockback_modifier
		var knockback = dir * knock_strength
		
		global_position += knockback

func spawn_effect(EFFECT: PackedScene, effect_position: Vector2 = global_position):
	if EFFECT:
		var effect = EFFECT.instantiate()
		get_tree().current_scene.add_child(effect)
		effect.global_position = effect_position
		return effect

func spawn_dmgIndicator(damage:int):
	var indicator = spawn_effect(INDICATOR_DAMAGE)
	if indicator:
		indicator.label.text = str(damage)

func _on_hurt_box_area_entered(area_entered):
	pass

func _on_Entity_died():
	die()
