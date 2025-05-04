extends CharacterBody3D

@onready var camera = $PlayerCamera

@export var speed := 5.0
@export var jump_velocity = 4.5

var can_jump = false
var coyote_frames = 0
const COYOTE_FRAMES_MAX = 20

@export var air_friction := 0.1
@export var air_acceleration := 0.3
@export var ground_friction := 0.3


func _physics_process(delta: float) -> void:
	
	
	# Reset coyote time
	if is_on_floor():
		can_jump = true
		coyote_frames = 0
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if coyote_frames < COYOTE_FRAMES_MAX:
			coyote_frames += 1

	# Handle jump.
	if Input.is_action_just_pressed("jump") and can_jump:
		if is_on_floor():
			velocity.y = jump_velocity
			can_jump = false
		elif not is_on_floor() and (coyote_frames < COYOTE_FRAMES_MAX):
			velocity.y = jump_velocity
			can_jump = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_move_direction := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var move_direction := (transform.basis * Vector3(input_move_direction.x, 0, input_move_direction.y)).normalized()
	
	# If player gives movement input
	if move_direction:
		if is_on_floor():
			velocity.x = move_direction.x * speed
			velocity.z = move_direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, move_direction.x * speed, air_acceleration)
			velocity.z = move_toward(velocity.z, move_direction.z * speed, air_acceleration)
	
	# If player stops directional input
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, ground_friction)
			velocity.z = move_toward(velocity.z, 0, ground_friction)
		else:
			velocity.x = move_toward(velocity.x, 0, air_friction)
			velocity.z = move_toward(velocity.z, 0, air_friction)

	move_and_slide()
	
	
