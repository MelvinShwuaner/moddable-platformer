extends Area2D

func Upgrade(body : Node2D):
	if(!body.double_jump):
		body.double_jump = true
		return
	if(!body.CanShoot):
		body.CanShoot = true
		return
	body.shoot_timer /= 2
func _on_body_entered(body: Node2D) -> void:
	for node in get_tree().get_nodes_in_group("players"):
		Upgrade(node)
		node.original_position = position
	Global.lives +=3
	queue_free()
