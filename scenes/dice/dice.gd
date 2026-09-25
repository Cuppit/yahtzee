extends GridContainer

const IN = true
const OUT = false

func unselect_dice():
	for child in get_children():
		if child is Die: 
			child.selected = false
			child.set_pressed(false)


# Gets a list of the current values of the dice,
# returns them as an array of integers.
func get_current_roll():
	var vals = []
	for child in get_children():
		if child is Die:
			vals.append(child.value)
	
	return vals

# Debug value manually sets the dice to a full house
func debug_set_dice(to_set):
	if to_set == "full_house":
		var first_three = 3
		for child in get_children():
			if child is Die:
				if first_three > 0:
					child.value = 1
					first_three -= 1
				else:
					child.value = 2
	elif to_set == "yahtzee":
		var randval = randi_range(1,6)
		for child in get_children():
			if child is Die:
				child.value=randval
	

# Identifies which dice are currently pressed (indicating they're "selected"),
# rolls them, and returns true.  
# If none of them were selected, returns false. [DEPRECATED]
func roll_selected() -> bool:
	var to_return = false
	for child in get_children():
		if child is Die:
			if child.button_pressed:
				to_return = true # Since at least one die was selected, set to return true.
				child.roll()
				child.button_pressed = false
	return to_return


# Identifies which dice are currently pressed (indicating they're "selected"),
# rolls all other dice, and returns true.  
# If all of them were selected, returns false.
func roll_unselected_dice() -> bool:
	var at_least_one_die_rolled = false
	for child in get_children():
		if child is Die:
			if not child.button_pressed:
				at_least_one_die_rolled = true # Since at least one die got rolled, set to return true.
				child.roll()
				# child.button_pressed = false
	return at_least_one_die_rolled


# Rolls all the dice.
func roll_all():
	for child in get_children():
		if child is Die:
			child.roll()


# Fade the dice into the screen.
# in_or_out = true: fades INTO visibility.
# in_or_out = false: fades OUT of visibility.
func fade(in_or_out=IN):
	if in_or_out == true:
		modulate = Color.TRANSPARENT
		visible = true
		var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(self, "modulate", Color(1,1,1,1), 1)
	else:
		modulate = Color(1,1,1,1)
		visible=true
		var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(self, "modulate", Color.TRANSPARENT, 1)
