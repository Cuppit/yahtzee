class_name Die
extends TextureButton

@onready var die_roll_snd_1 = $DieRoll1
@onready var die_roll_snd_2 = $DieRoll2
@onready var die_roll_snd_3 = $DieRoll3
@onready var die_roll_snd_4 = $DieRoll4
@onready var die_roll_snd_5 = $DieRoll5
@onready var die_roll_snd_6 = $DieRoll6

@onready var sel_ind = $SelectionIndicator

var dieroll_sounds = []

var dice_spriteframes = preload("res://assets/custom_resources/dice.tres")

var selected:bool = false

var value:int = 1:
	set(val):
		value = clamp(val,1,6)
		texture_normal = dice_spriteframes.get_frame_texture("dice", val-1)
		
# Rolls the die
func roll():
	value = randi_range(1, 6) 
	dieroll_sounds = [die_roll_snd_1,die_roll_snd_2,die_roll_snd_3,die_roll_snd_4,die_roll_snd_5,die_roll_snd_6]
	dieroll_sounds[randi_range(0,5)].play()

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
