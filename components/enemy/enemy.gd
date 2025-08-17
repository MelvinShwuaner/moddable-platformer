class_name Enemy
extends CharacterBody2D
#can the enemy fire bullets?
@export var Shoots : bool = true
#can the enemy Duplicate?
@export var Duplicates: bool = true
#can the enemy Fly?
@export var Flies : bool = true
## How fast does your enemy move?
@export_range(0, 1000, 10, "suffix:px/s") var speed: float = 100.0:
	set = _set_speed
#the cooldown for duplication
@export_range(5, 20, 1, "suffix:px/s") var DuplicateCooldown: float = 5.0
var DuplicateTimer = DuplicateCooldown
## Does the enemy fall off edges?
@export var fall_off_edge: bool = true
@export_range(0, 10, 1, "suffix:px/s") var BulletCooldown: float = 1
var CoolDown = BulletCooldown
@export_range(0, 10, 1, "suffix:px/s") var BulletKnockBack: float = 1
var Bullet = preload("res://EnemyBullet.tscn")
var Coin = preload("res://components/coin/coin.tscn")
## Does the player lose a life when contacting the enemy?
@export var player_loses_life: bool = true
##how much hits required to kill
@export var Health: float = 5;
## Can the enemy be squashed by the player?
@export var squashable: bool = true

## The direction the enemy will start moving in.
@export_enum("Left:0", "Right:1") var start_direction: int = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction: int

@onready var _sprite := %AnimatedSprite2D
@onready var _left_ray := %LeftRay
@onready var _right_ray := %RightRay
func Destroy():
	var coin = Coin.instantiate()
	get_parent().add_child(coin)
	coin.position = position
	coin.position.y -= 50
	queue_free()

func _set_speed(new_speed):
	speed = new_speed
	if not is_node_ready():
		await ready
	if speed == 0:
		_sprite.speed_scale = 0
	else:
		_sprite.speed_scale = speed / 100


func _ready():
	Global.gravity_changed.connect(_on_gravity_changed)

	direction = -1 if start_direction == 0 else 1

func Shoot(Pos): 
	var bullet = Bullet.instantiate()
	bullet.KnockBack = -BulletKnockBack
	bullet.Shooter = self
	get_parent().add_child(bullet)
	bullet.position = position
	bullet.position.y -= 50
	bullet.linear_velocity = (Pos - position).normalized() * 2000
func Duplicate():
	var Node = self.duplicate()
	Node.Health = 1;
	get_parent().add_child(Node)
func _physics_process(delta):
	var player = get_tree().get_nodes_in_group("players").get(0);
	if(Shoots):
		CoolDown -= delta;
		if(CoolDown <= 0):
			CoolDown = BulletCooldown
			var pos = player.position
			pos.y -= 50
			Shoot(pos)
	if(Flies && player.position.y < position.y):
		velocity.y += -gravity * delta
	else:
		velocity.y += gravity * delta
	if(Duplicates):
		DuplicateTimer -= delta
		if(DuplicateTimer <= 0):
			DuplicateTimer = DuplicateCooldown
			Duplicate()
	if(player.position.	x > position.x):
			direction = 1
	else: direction = -1
	if not fall_off_edge and (!_left_ray.is_colliding() or !_right_ray.is_colliding()):
		if(direction == 1 && !_right_ray.is_colliding()):
			direction = -1
		elif(direction == -1 && !_left_ray.is_colliding()):
			direction = 1
	if(abs(velocity.x) < speed && velocity.x / direction == abs(velocity.x)):
		velocity.x += direction * speed * delta
	else:
		if(velocity.x > 0):
			velocity.x -= speed * delta
		else:
			velocity.x += speed * delta
	_sprite.flip_h = velocity.x < 0
	move_and_slide()

	#if velocity.x == 0 and is_on_floor():
		#direction *= -1
func _on_gravity_changed(new_gravity):
	gravity = new_gravity
func LoseHealth(Damage):
	Health-=Damage;
	if(Health <= 0):
		Destroy()
	else :
		speed += speed * Damage
func _on_hitbox_body_entered(body):
	if body.is_in_group("players"):
		if squashable and body.velocity.y > 0 and body.position.y < position.y:
			LoseHealth(1)
			body.stomp()
		elif player_loses_life:
			Global.lives -= 1
