extends Position2D
tool

export var ship_texture : Texture setget change_texture
const TWEEN_DURATION = 0.3

var position_start = Vector2()

signal stop_invincible
signal completed

onready var tween = $Tween
onready var anim = $AnimationPlayer

func change_texture(new_value):
	ship_texture = new_value
	if $Sprite:
		$Sprite.texture = ship_texture
		
func play_disappear():
	anim.play("disappear")
	yield(anim, "animation_finished")

func play_idle():
	anim.play("idle")
	yield(anim, "animation_finished")

func invincible():
	anim.play("invincible")
	yield(anim, "animation_finished")
	emit_signal("stop_invincible")

func update_charge_feedback(charge, max_charge, max_overcharge):
	# charge feedback
	var c = min(charge,max_charge)/max_charge
	$ChargeBar/Charge.set_point_position(1, $ChargeBar/ChargeAxis.points[1] * c)
	$ChargeBar/Tip.position = $ChargeBar/ChargeAxis.points[1] * c
	$ForwardChargeBar/Charge.set_point_position(1, $ForwardChargeBar/ChargeAxis.points[1] * c)
	$ForwardChargeBar/Tip.position = $ForwardChargeBar/ChargeAxis.points[1] * c
	
	# overcharge feedback
	if charge > max_charge + (max_overcharge-max_charge)/2:
		$ChargeBar.visible = int(floor(charge * 15)) % 2
		$ForwardChargeBar.visible = int(floor(charge * 15)) % 2
	elif charge == 0:
		$ChargeBar.visible = false
		$ForwardChargeBar.visible = false
	else:
		$ChargeBar.visible = true
		$ForwardChargeBar.visible = true
		