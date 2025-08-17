extends Area2D

func Upgrade(body : Node2D):
	if(!body.double_jump):
		body.double_jump = true
		return
	body.CanShoot = true
func _on_body_entered(body: Node2D) -> void:
	Upgrade(body)
	body.original_position = position
	Global.lives +=3
	queue_free()
