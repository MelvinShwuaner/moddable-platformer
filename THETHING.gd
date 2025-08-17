extends AnimatableBody2D
@export var Speed : float = 16
@export var Distance : float = 8000
@export var Cooldown : float = 10
var cooldown = 0
var Target = position
func _physics_process(delta: float) -> void:
	move_and_collide((Target-position).normalized() * Speed)
	cooldown -= delta
	if(cooldown <= 0):
		cooldown = Cooldown
		var x = randf_range(-Distance, Distance)
		var y = randf_range(-Distance/2, Distance/2)
		Target = position + Vector2(x,y)
	rotate(delta*2)
	
