extends CharacterBody3D

@export_category("configs")
@export var speed = 5.0
@export var jump_velocity = 3.5


@export_category("sensitivity")
@export var mouse_sensitivity := 0.09
@export var cam_limt_down = -70.0
@export var cam_limt_cima = 60.0


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var cam_vertical := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
			
			cam_vertical -= event.relative.y * mouse_sensitivity
			cam_vertical = clamp(cam_vertical, cam_limt_down, cam_limt_cima)
			$head/vertical.rotation_degrees.x = cam_vertical
			
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir = Input.get_vector("esquerda", "direita", "frente", "traz")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
