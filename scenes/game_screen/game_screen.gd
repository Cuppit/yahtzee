extends Control



@onready var dice = $Dice
@onready var score_sheet = $ScoreSheet
@onready var lbl_reroll_meter = $lblRerollMeter
@onready var btn_roll = $btnRoll
@onready var btn_game_start = $btnGameStart
@onready var lbl_no_dice_selected = $lblNoDiceSelected
@onready var tmr_no_dice_selected_msg_timeout = $tmrNoDiceSelectedMsgTimeout
@onready var lbl_no_rerolls_left = $lblNoRerollsLeft
@onready var tmr_no_rerolls_left = $tmrNoRerollsLeft
@onready var lbl_keep_dice = $lblKeepDice

var rerolls:int = 2:
	set(val):
		rerolls = clamp(val,0,2)
		lbl_reroll_meter.text = "REROLLS LEFT: "+str(rerolls)


func _on_roll_pressed():
	lbl_keep_dice.visible = false
	if rerolls > 0: 
		# Check to see if at least one die has been selected to reroll
		if not dice.roll_unselected_dice(): # If a roll attempt was made when no dice were selected:
			lbl_no_dice_selected.visible = true
			tmr_no_dice_selected_msg_timeout.start()
		else:
			# Presumably roll successfully happened, decrement remaining rerolls
			rerolls -= 1
			
			# Pass the current value of the dice to the scoresheet; the scoresheet
			# will then update the sheet with what options the player has.
			score_sheet.update_options(dice.get_current_roll())
			
	else:
		lbl_no_rerolls_left.visible = true
		tmr_no_rerolls_left.start()
	
	
	


func _on_btn_game_start_pressed():
	dice.roll_all()
	score_sheet.update_options(dice.get_current_roll())
	# Reset the score sheet
	# TODO 20260823: If it becomes necessary, write a function to reset the 
	# initial state of the score sheet.
	
	# Display the relevant UI components
	dice.visible = true
	btn_roll.visible = true
	lbl_reroll_meter.visible = true
	lbl_keep_dice.visible = true
	btn_game_start.visible=false


func _on_tmr_no_dice_selected_msg_timeout_timeout():
	lbl_no_dice_selected.visible = false


func _on_tmr_no_rerolls_left_timeout():
	lbl_no_rerolls_left.visible = false


func _on_btn_debug_set_full_house_pressed():
	dice.debug_set_dice("yahtzee")
	score_sheet.update_options(dice.get_current_roll())
