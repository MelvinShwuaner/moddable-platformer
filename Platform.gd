extends AnimatableBody2D
@export var CoinsRequired : int = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("players") && Global.coins >= CoinsRequired):
		get_node("Animator").play("Animation")
