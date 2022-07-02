extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")
#preload scene

func destroyGrass():
	var grassEffect = GrassEffect.instance()
	#instance preloaded scene
	get_parent().add_child(grassEffect)
	#add instanced scene as child node to parent node (ysort) of Grass.tscn
	grassEffect.global_position = global_position
	#set position of instanced scene



func _on_Hurtbox_area_entered(area):
	destroyGrass()
	queue_free()
 
