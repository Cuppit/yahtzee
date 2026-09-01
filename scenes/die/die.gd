class_name Die
extends TextureButton

@onready var sel_ind = $SelectionIndicator

var dice_spriteframes = preload("res://assets/custom_resources/dice.tres")

var selected:bool = false

var value:int = 1:
	set(val):
		value = clamp(val,1,6)
		texture_normal = dice_spriteframes.get_frame_texture("dice", val-1)
		
# Rolls the die
func roll():
	value = randi_range(1, 6) 

func _on_pressed():
	pass
	#roll()


func _on_toggled(toggled_on):
	if toggled_on:
		# TODO 20260819: Design and implement "visibility tweening" to have
		# the selection indicator "fade-in" and "fade-out" when the die is
		# selected / deselected
		sel_ind.visible=true
		selected = true
	else:
		sel_ind.visible=false
		selected = false
	
	print("Die is set to selected?:",selected)
