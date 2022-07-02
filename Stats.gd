extends Node

#PlayerStats inherits from Stats.tscn

export var maxHealth = 3
onready var health = maxHealth setget setHealth
#setget: use this function each time this variable is set

signal noHealth

func setHealth(value):
	health = value
	if health <=0:
		emit_signal("noHealth")
