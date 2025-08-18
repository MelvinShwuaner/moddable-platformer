extends AnimatableBody2D
@export var CoinsRequired : int = 0
@export var animation : String = "Animation"
func Move():
	get_node("Animator").play(animation)
func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("players") && Global.coins >= CoinsRequired):
		Move()
