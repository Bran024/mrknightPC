extends AnimatedSprite


func _ready():
	connect("animation_finished", self, "_on_animation_finished")
	frame = 0
	#not neccessary, but will help ensure effect animations begin playing on first frame
	play("Animate")

func _on_animation_finished():
	queue_free()
