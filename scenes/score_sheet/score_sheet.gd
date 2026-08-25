extends ColorRect
## The score sheet class is the UI component of the game.  For now, it both
## presents a player's score, and it also holds the player's scores.

# --signals

# --enums

# --constants

# -- static variables

# -- @export variables

# -- remaining regular variables

# Stores the current point value each field of the scoresheet currently has
var scores:Dictionary = {
	"aces":0,
	"twos":0,
	"threes":0,
	"fours":0,
	"fives":0,
	"sixes":0,
	"three_of_a_kind":0,
	"four_of_a_kind":0,
	"full_house":0,
	"sm_straight":0,
	"lg_straight":0,
	"yahtzee":0,
	"chance":0,
	"yahtzee_bonus":0
}


var categories_available:Dictionary = {
	"aces":true,
	"twos":true,
	"threes":true,
	"fours":true,
	"fives":true,
	"sixes":true,
	"three_of_a_kind":true,
	"four_of_a_kind":true,
	"full_house":true,
	"sm_straight":true,
	"lg_straight":true,
	"yahtzee":true,
	"chance":true,
	"yahtzee_bonus":true
}


# @onready variables
# TODO 20260822: Add remaining scene nodes before adding functionality to other nodes
@onready var btn_score_aces = $HBoxContainer/VBoxContainer/UpperSection/Aces/Score/btnScore
@onready var lbl_score_aces = $HBoxContainer/VBoxContainer/UpperSection/Aces/Score/lblScore
@onready var btn_score_twos = $HBoxContainer/VBoxContainer/UpperSection/Twos/Score/btnScore
@onready var lbl_score_twos = $HBoxContainer/VBoxContainer/UpperSection/Twos/Score/lblScore
@onready var btn_score_threes = $HBoxContainer/VBoxContainer/UpperSection/Threes/Score/btnScore
@onready var lbl_score_threes = $HBoxContainer/VBoxContainer/UpperSection/Threes/Score/lblScore
@onready var btn_score_fours = $HBoxContainer/VBoxContainer/UpperSection/Fours/Score/btnScore
@onready var lbl_score_fours = $HBoxContainer/VBoxContainer/UpperSection/Fours/Score/lblScore
@onready var btn_score_fives = $HBoxContainer/VBoxContainer/UpperSection/Fives/Score/btnFivesScore
@onready var lbl_score_fives = $HBoxContainer/VBoxContainer/UpperSection/Fives/Score/lblFivesScore
@onready var btn_score_sixes = $HBoxContainer/VBoxContainer/UpperSection/Sixes/Score/btnScore
@onready var lbl_score_sixes = $HBoxContainer/VBoxContainer/UpperSection/Sixes/Score/lblScore 

@onready var lbl_score_subtotal_uppersect = $HBoxContainer/VBoxContainer/UpperSection/UpperSubtotal/Score/lbl
@onready var lbl_score_bonus_uppersect = $HBoxContainer/VBoxContainer/UpperSection/UpperBonus/Score/lbl
@onready var lbl_score_total_uppersect = $HBoxContainer/VBoxContainer/UpperSection/UpperTotal/Score/lbl

@onready var btn_three_of_a_kind = $HBoxContainer/LowerSection/ThreeOfAKind/ThreeOfAKindScore/btnThreeOfAKind
@onready var lbl_three_of_a_kind = $HBoxContainer/LowerSection/ThreeOfAKind/ThreeOfAKindScore/lblThreeOfAKind
@onready var btn_four_of_a_kind = $HBoxContainer/LowerSection/FourOfAKind/Score/btnScore
@onready var lbl_four_of_a_kind = $HBoxContainer/LowerSection/FourOfAKind/Score/lblScore
@onready var btn_full_house = $HBoxContainer/LowerSection/FullHouse/Score/btnScore
@onready var lbl_full_house = $HBoxContainer/LowerSection/FullHouse/Score/lblScore
@onready var btn_small_straight = $HBoxContainer/LowerSection/SmallStraight/Score/btnScore
@onready var lbl_small_straight = $HBoxContainer/LowerSection/SmallStraight/Score/lblScore
@onready var btn_large_straight = $HBoxContainer/LowerSection/LargeStraight/Score/btnScore
@onready var lbl_large_straight = $HBoxContainer/LowerSection/LargeStraight/Score/lblScore
@onready var btn_yahtzee = $HBoxContainer/LowerSection/Yahtzee/Score/btnScore
@onready var lbl_yahtzee = $HBoxContainer/LowerSection/Yahtzee/Score/lblScore
@onready var btn_chance = $HBoxContainer/LowerSection/Chance/Score/btnScore
@onready var lbl_chance =  $HBoxContainer/LowerSection/Chance/Score/lblScore
@onready var btn_yahtzee_bonus = $HBoxContainer/LowerSection/YahtzeeBonus/Score/btnScore
@onready var lbl_yahtzee_bonus = $HBoxContainer/LowerSection/YahtzeeBonus/Score/lblScore

# Part of a method to make iteration over the buttons simpler
var score_buttons = [btn_score_aces,btn_score_twos,btn_score_threes,btn_score_fours,
		btn_score_fives,btn_score_sixes,btn_three_of_a_kind,btn_four_of_a_kind,btn_full_house,
		btn_small_straight,btn_large_straight,btn_yahtzee,btn_chance,btn_yahtzee_bonus]

var score_labels = [lbl_score_aces,lbl_score_twos,lbl_score_threes,lbl_score_fours,
		lbl_score_fives,lbl_score_sixes,lbl_three_of_a_kind,lbl_four_of_a_kind,lbl_full_house,
		lbl_small_straight,lbl_large_straight,lbl_yahtzee,lbl_chance,lbl_yahtzee_bonus]

# Updates score values portrayed on the 
# TODO 20260824: FINISH update_options() FUNCTION
# Decide optimal procedure (generate scores for this point in the game first,
# THEN assign labels?  or assign the labels immediately?
func update_options(dice_vals):

	# Grab the UI buttons again, since they might have been nil when they were 
	# grabbed at scene startup
	score_buttons = [btn_score_aces,btn_score_twos,btn_score_threes,btn_score_fours,
			btn_score_fives,btn_score_sixes,btn_three_of_a_kind,btn_four_of_a_kind,btn_full_house,
			btn_small_straight,btn_large_straight,btn_yahtzee,btn_chance,btn_yahtzee_bonus]

	score_labels = [lbl_score_aces,lbl_score_twos,lbl_score_threes,lbl_score_fours,
			lbl_score_fives,lbl_score_sixes,lbl_three_of_a_kind,lbl_four_of_a_kind,lbl_full_house,
			lbl_small_straight,lbl_large_straight,lbl_yahtzee,lbl_chance,lbl_yahtzee_bonus]

	var score = 0
	var cats = categories_available.keys()
	for cat in range(0,len(cats)):
		score = 0
		if categories_available.keys()[cat] in ["aces","twos","threes","fours","fives","sixes"]:
			for val in dice_vals:
				if val == cat+1:
					score += val
			print("About to write to the object")
			score_buttons[cat].text = str(score)
