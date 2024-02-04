extends Panel

@onready var sprite = $Sprite2D

func showFilled(filled: bool):
	if filled: sprite.frame = 0
	else: sprite.frame = 4
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
