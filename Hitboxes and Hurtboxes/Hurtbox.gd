extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

onready var timer = $Timer

var invinc = false setget setInvinc
#setget: use this function each time this variable is set/changes

signal invincStarted
signal invincEnded

func setInvinc(value):
	invinc = value
	if invinc == true:
		emit_signal("invincStarted")
	else:
		emit_signal("invincEnded")

func startInvinc(duration):
	self.invinc = true
	timer.start(duration)
	

func create_hit_effect(area):
		var effect = HitEffect.instance()
		var main = get_tree().current_scene
		main.add_child(effect)
		effect.global_position = global_position
		#instancing hit effect upon successful attack - using heartbeast hiteffect.png for now but
		#it does not really match the theme

func _on_Timer_timeout():
	self.invinc = false

func _on_Hurtbox_invincStarted():
	set_deferred("monitorable", false)


func _on_Hurtbox_invincEnded():
	set_deferred("monitorable", true)
