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
@onready var lbl_turns_remaining = $lblTurnsRemaining

var rerolls:int = 2:
	set(val):
		rerolls = clamp(val,0,2)
		lbl_reroll_meter.text = "REROLLS LEFT: "+str(rerolls)

var turns_remaining:int = 13:
	set(val):
		turns_remaining = val
		if turns_remaining == 0: 
			lbl_turns_remaining.text = str("TURNS REMAINING: --- ",\
					"\nCURRENT TURN: 13 (FINAL TURN)")
		elif turns_remaining > -1:
			lbl_turns_remaining.text = str("TURNS REMAINING: ",str(turns_remaining),\
					"\nCURRENT TURN: ",str(13-turns_remaining))
		else:
			lbl_turns_remaining.text = str("TURNS REMAINING: --- ",\
					"\nCURRENT TURN: 13 (GAME OVER)")


func start_next_turn(first_turn=false):
	turns_remaining -= 1
	#turns_remaining = turns_remaining if first_turn else (turns_remaining-1)
	rerolls = 2
	dice.unselect_dice()
	dice.roll_all()
	score_sheet.update_options(dice.get_current_roll())


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
	

# called whenever the player claims a score for a category 
func process_cat_claim():
	# Check if there are any more available categories
	if true in (score_sheet.categories_available.values()):
		print("still some categories available, beginning a new round:")
		start_next_turn()
	
	
func _on_btn_game_start_pressed():
	print("GAME STARTED")
	score_sheet.score_category_claimed.connect(func(): process_cat_claim())
	start_next_turn(true)
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
	dice.debug_set_dice("full_house")
	score_sheet.update_options(dice.get_current_roll())


func _on_btn_debug_set_yahtzee_pressed():
	dice.debug_set_dice("yahtzee")
	score_sheet.update_options(dice.get_current_roll())
