extends RigidBody2D
var KnockBack = 1;
var Shooter
func _on_body_entered(body: Node) -> void:
	queue_free()
	if(body.is_in_group("players")):
		body.velocity += (body.position-Shooter.position).normalized() * KnockBack * 100;
