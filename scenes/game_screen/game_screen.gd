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
@onready var asp_airport_lounge = $aspAirportLounge

@onready var lbl_end_game_msg = $lblEndGameMsg
@onready var btn_play_again = $btnPlayAgain

var scoresheet_original_pos

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
	if turns_remaining < 0:
		end_game()

	rerolls = 2
	dice.unselect_dice()
	dice.roll_all()
	score_sheet.update_options(dice.get_current_roll())
	


func end_game():
	btn_roll.visible = false
	lbl_reroll_meter.visible = false
	lbl_turns_remaining.visible = false
	lbl_keep_dice.visible = false
	dice.fade(false) # Or "fade OUT"
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_ELASTIC)
	#tween.set_parallel()
	# Center-of-screen position formula: score_sheet.position.x-((get_viewport().get_visible_rect().size.x-score_sheet.size.x)/2)
	tween.tween_property(score_sheet, "position", Vector2(0,score_sheet.position.y), 2.5)
	
	lbl_end_game_msg.text = "Congratulations!\n  Your final score\n was:\n"+str(score_sheet.get_grand_total())
	
	tween.set_trans(Tween.TRANS_CUBIC)
	lbl_end_game_msg.modulate = Color.TRANSPARENT
	lbl_end_game_msg.visible = true
	tween.tween_property(lbl_end_game_msg, "modulate", Color(1,1,1,1),2)
	# btn_play_again.modulate = Color.TRANSPARENT
	btn_play_again.visible = true
	tween.tween_property(btn_play_again, "position", Vector2(btn_play_again.position.x-312,btn_play_again.position.y),0.5)
	
	
	
	
	#tween.tween_property($Sprite, "scale", Vector2(), 1.0)
	#tween.tween_callback($Sprite.queue_free)
	
	


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
	
# Resets the game
func reset_game():
	lbl_end_game_msg.visible = false
	btn_play_again.visible = false
	btn_play_again.position.x += 312
	
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(score_sheet, "position", scoresheet_original_pos, 0.5)
	score_sheet.reset_scoresheet()
	
	turns_remaining = 13
	dice.fade()
	start_next_turn(true)
		
	btn_roll.visible = true
	lbl_reroll_meter.visible = true
	lbl_keep_dice.visible = true
	btn_game_start.visible=false
	lbl_turns_remaining.visible = true


func _ready():
	scoresheet_original_pos = score_sheet.position
	print("The scoresheet_original_pos value is: ",str(scoresheet_original_pos))


func _on_btn_game_start_pressed():
	print("GAME STARTED")
	score_sheet.score_category_claimed.connect(func(): process_cat_claim())
	start_next_turn(true)
	
	# Display the relevant UI components
	dice.fade()
	btn_roll.visible = true
	lbl_reroll_meter.visible = true
	lbl_keep_dice.visible = true
	btn_game_start.visible=false
	asp_airport_lounge.play()


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


func _on_btn_play_again_pressed():
	reset_game()
