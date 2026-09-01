extends ColorRect
## The score sheet class is the UI component of the game.  For now, it both
## presents a player's score, and it also holds the player's scores.

# --signals
signal score_category_claimed

# --enums

# --constants
const SMALL = false
const LARGE = true
const THREE = false
const FOUR = true

# -- static variables

# -- @export variables

# -- remaining regular variables
var last_dice_vals = [1,1,1,1,1]

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
@onready var btn_score_aces = $HBoxContainer/VBoxContainer/UpperSection/Aces/Score/btn
@onready var lbl_score_aces = $HBoxContainer/VBoxContainer/UpperSection/Aces/Score/lbl
@onready var btn_score_twos = $HBoxContainer/VBoxContainer/UpperSection/Twos/Score/btn
@onready var lbl_score_twos = $HBoxContainer/VBoxContainer/UpperSection/Twos/Score/lbl
@onready var btn_score_threes = $HBoxContainer/VBoxContainer/UpperSection/Threes/Score/btn
@onready var lbl_score_threes = $HBoxContainer/VBoxContainer/UpperSection/Threes/Score/lbl
@onready var btn_score_fours = $HBoxContainer/VBoxContainer/UpperSection/Fours/Score/btn
@onready var lbl_score_fours = $HBoxContainer/VBoxContainer/UpperSection/Fours/Score/lbl
@onready var btn_score_fives = $HBoxContainer/VBoxContainer/UpperSection/Fives/Score/btn
@onready var lbl_score_fives = $HBoxContainer/VBoxContainer/UpperSection/Fives/Score/lbl
@onready var btn_score_sixes = $HBoxContainer/VBoxContainer/UpperSection/Sixes/Score/btn
@onready var lbl_score_sixes = $HBoxContainer/VBoxContainer/UpperSection/Sixes/Score/lbl 

@onready var lbl_score_subtotal_uppersect = $HBoxContainer/VBoxContainer/UpperSection/UpperSubtotal/Score/lbl
@onready var lbl_score_bonus_uppersect = $HBoxContainer/VBoxContainer/UpperSection/UpperBonus/Score/lbl
@onready var lbl_score_total_uppersect = $HBoxContainer/VBoxContainer/UpperSection/UpperTotal/Score/lbl

@onready var btn_three_of_a_kind = $HBoxContainer/LowerSection/ThreeOfAKind/ThreeOfAKindScore/btn
@onready var lbl_three_of_a_kind = $HBoxContainer/LowerSection/ThreeOfAKind/ThreeOfAKindScore/lbl
@onready var btn_four_of_a_kind = $HBoxContainer/LowerSection/FourOfAKind/Score/btn
@onready var lbl_four_of_a_kind = $HBoxContainer/LowerSection/FourOfAKind/Score/lbl
@onready var btn_full_house = $HBoxContainer/LowerSection/FullHouse/Score/btn
@onready var lbl_full_house = $HBoxContainer/LowerSection/FullHouse/Score/lbl
@onready var btn_small_straight = $HBoxContainer/LowerSection/SmallStraight/Score/btn
@onready var lbl_small_straight = $HBoxContainer/LowerSection/SmallStraight/Score/lbl
@onready var btn_large_straight = $HBoxContainer/LowerSection/LargeStraight/Score/btn
@onready var lbl_large_straight = $HBoxContainer/LowerSection/LargeStraight/Score/lbl
@onready var btn_yahtzee = $HBoxContainer/LowerSection/Yahtzee/Score/btn
@onready var lbl_yahtzee = $HBoxContainer/LowerSection/Yahtzee/Score/lbl
@onready var btn_chance = $HBoxContainer/LowerSection/Chance/Score/btn
@onready var lbl_chance =  $HBoxContainer/LowerSection/Chance/Score/lbl
@onready var btn_yahtzee_bonus = $HBoxContainer/LowerSection/YahtzeeBonus/Score/btn
@onready var lbl_yahtzee_bonus = $HBoxContainer/LowerSection/YahtzeeBonus/Score/lbl

@onready var lbl_score_subtotal_lowersect = $HBoxContainer/LowerSection/LowerSectionTotal/Score/lbl
@onready var lbl_score_uppersecttotal_lowersect = $HBoxContainer/LowerSection/UpperSectionTotal/Score/lbl
@onready var lbl_score_grandtotal_uppersect = $HBoxContainer/LowerSection/GrandTotal/Score/lbl


# Part of a method to make iteration over the buttons simpler
var score_buttons = [btn_score_aces,btn_score_twos,btn_score_threes,btn_score_fours,
		btn_score_fives,btn_score_sixes,btn_three_of_a_kind,btn_four_of_a_kind,btn_full_house,
		btn_small_straight,btn_large_straight,btn_yahtzee,btn_chance,btn_yahtzee_bonus]

var score_labels = [lbl_score_aces,lbl_score_twos,lbl_score_threes,lbl_score_fours,
		lbl_score_fives,lbl_score_sixes,lbl_three_of_a_kind,lbl_four_of_a_kind,lbl_full_house,
		lbl_small_straight,lbl_large_straight,lbl_yahtzee,lbl_chance,lbl_yahtzee_bonus]


func is_full_house(dice_vals):
	var uniq = {}
	for val in dice_vals: 
		if uniq.has(val):
			uniq[val] += 1
		else:
			uniq[val] = 1
	var to_test = uniq.values()
	to_test.sort()
	return to_test == [2,3]


# Checks whether the given dice values are three/four of a kind (depending on
# setting of "three_or_four".
# dice_vals: the values of the dice.
# three_or_four: flag to indicate whether checking for 3 or 4 of a kind.
func is_of_a_kind(dice_vals, three_or_four):
	var uniq={}
	for val in dice_vals:
		if uniq.has(val):
			uniq[val] += 1
		else:
			uniq[val] = 1
	var to_test = uniq.values()
	to_test.sort()
	if three_or_four == THREE:
		return true if to_test[-1] == 3 else false
	elif three_or_four == FOUR:
		return true if to_test[-1] == 4 else false

# Returns whether the dice are a straight.  
# dice_vals: list of 5 int values that are the current values of the dice.
# sm_or_lg: boolean value indicating whether to check for a small straight
# or a large one.
func is_straight(dice_vals, sm_or_lg):
	var to_return = true
	dice_vals.sort()
	var diffs = []
	var x = 0
	while x < len(dice_vals)-1:
		diffs.append(dice_vals[x+1]-dice_vals[x])
		x += 1
	x=0
	if sm_or_lg == LARGE:
		while x < len(diffs):
			if diffs[x] != 1:
				to_return = false
			x += 1
	else:
		# Check for 3 consecutive ones in the diffs list.
		var ones = 0
		while x < len (diffs):
			if diffs[x] == 1:
				ones += 1
			x += 1
		return false if ones < 3 else true
	return to_return


# Determines the point value of a set of dice in the specified category
# dice_vals: the array of values of the dice
# cat: the named category to determine the score for
func get_score(dice_vals, cat):
	var score = 0
	if cat in ["aces","twos","threes","fours","fives","sixes"]:
		for val in dice_vals:
			if val == categories_available.keys().find(cat)+1:
				score += val
	elif cat=="three_of_a_kind":
		if (is_of_a_kind(dice_vals, THREE) or is_of_a_kind(dice_vals, FOUR)):
			for val in dice_vals:
				score += val
	elif cat=="four_of_a_kind":
		if (is_of_a_kind(dice_vals, FOUR)):
			for val in dice_vals:
				score += val
	elif cat == "full_house":
		score = 25 if is_full_house(dice_vals) else 0	
	elif cat == "sm_straight":
		score = 30 if is_straight(dice_vals, SMALL) else 0
	elif cat == "lg_straight":
		score = 40 if is_straight(dice_vals, LARGE) else 0
	elif cat == "chance":
		for val in dice_vals:
			score += val
	elif cat == "yahtzee":
		var is_a_yahtzee = true
		for val in dice_vals:
			if val != dice_vals[0]:
				is_a_yahtzee = false
		score = 50 if is_a_yahtzee else 0

	return score


# Updates the 
func update_score_totals():
	# TODO 20260831: Finish updating score totals
	var uppersect_subtot = 0
	var uppersect_bonus = 0
	var lowersect_subtot = 0
	
	
	for cat in scores:
		print("adding ",cat," to subtotal:")
		if cat in ["aces","twos","threes","fours","fives","sixes"]:
			uppersect_subtot += scores[cat]
		
		if cat in ["three_of_a_kind","four_of_a_kind","full_house","sm_straight","lg_straight","yahtzee","chance","yahtzee_bonus"]:
			lowersect_subtot += scores[cat]
	
	uppersect_bonus = 35 if uppersect_subtot >= 63 else 0
	
	lbl_score_subtotal_uppersect.text = str(uppersect_subtot)
	lbl_score_bonus_uppersect.text = str(uppersect_bonus)
	lbl_score_total_uppersect.text = str(uppersect_subtot + uppersect_bonus)
	
	
	lbl_score_subtotal_lowersect.text = str(lowersect_subtot)
	lbl_score_uppersecttotal_lowersect.text = str(uppersect_subtot + uppersect_bonus)
	lbl_score_grandtotal_uppersect.text = str(lowersect_subtot + uppersect_subtot + uppersect_bonus)
	
	pass


# Checks
func enable_buttons_by_availability():
	score_buttons = [btn_score_aces,btn_score_twos,btn_score_threes,btn_score_fours,
			btn_score_fives,btn_score_sixes,btn_three_of_a_kind,btn_four_of_a_kind,btn_full_house,
			btn_small_straight,btn_large_straight,btn_yahtzee,btn_chance,btn_yahtzee_bonus]
	score_labels = [lbl_score_aces,lbl_score_twos,lbl_score_threes,lbl_score_fours,
			lbl_score_fives,lbl_score_sixes,lbl_three_of_a_kind,lbl_four_of_a_kind,lbl_full_house,
			lbl_small_straight,lbl_large_straight,lbl_yahtzee,lbl_chance,lbl_yahtzee_bonus]
			
	var catkeys = categories_available.keys()
	for cat in range (0, len(catkeys)):
		score_buttons[cat].disabled = false if categories_available[catkeys[cat]] else true


# Updates score values portrayed on the 
# TODO 20260824: FINISH update_options() FUNCTION
# Decide optimal procedure (generate scores for this point in the game first,
# THEN assign labels?  or assign the labels immediately?
func update_options(dice_vals):
	
	# Store this "hand" of dice for subsequent use by the scoring buttons
	last_dice_vals = dice_vals
	
	# Grab the UI buttons again, since they might have been nil when they were 
	# grabbed at scene startup
	score_buttons = [btn_score_aces,btn_score_twos,btn_score_threes,btn_score_fours,
			btn_score_fives,btn_score_sixes,btn_three_of_a_kind,btn_four_of_a_kind,btn_full_house,
			btn_small_straight,btn_large_straight,btn_yahtzee,btn_chance,btn_yahtzee_bonus]
	score_labels = [lbl_score_aces,lbl_score_twos,lbl_score_threes,lbl_score_fours,
			lbl_score_fives,lbl_score_sixes,lbl_three_of_a_kind,lbl_four_of_a_kind,lbl_full_house,
			lbl_small_straight,lbl_large_straight,lbl_yahtzee,lbl_chance,lbl_yahtzee_bonus]
	
	# Check for available categories, and enable score buttons accordingly
	enable_buttons_by_availability()
	
	# Update the appropriate buttons with text as necessary
	var score = 0
	var cats = categories_available.keys()
	for cat in range(0,len(cats)):
		if (categories_available[cats[cat]]):
			score = 0
			if cats[cat] in ["aces","twos","threes","fours","fives","sixes"]:
				for val in dice_vals:
					if val == cat+1:
						score += val
				print("About to write to the object")
			elif cats[cat] in ["three_of_a_kind","four_of_a_kind"]:
				if (is_of_a_kind(dice_vals, THREE) or is_of_a_kind(dice_vals, FOUR)):
					for val in dice_vals:
						score += val
			elif cats[cat] == "full_house":
				score = 25 if is_full_house(dice_vals) else 0
			elif cats[cat] == "sm_straight":
				score = 30 if is_straight(dice_vals, SMALL) else 0
			elif cats[cat] == "lg_straight":
				score = 40 if is_straight(dice_vals, LARGE) else 0
			score_buttons[cat].text = str(get_score(dice_vals, cats[cat]))
	


# Functionality for applying a score to a category, in response to the player
# clicking on the button associated with that category.
func _on_btn_pressed(pressed_btn):
	print("button pressed: ",pressed_btn)
	print("test")
	var cat = categories_available.keys()[score_buttons.find(pressed_btn)]
	# Mark appropriate category as "unavailable"
	categories_available[cat] = false
	#print([1, 2, 3].reduce(func(accum, number): return accum + number, 10))
	
	# Godot equivalent of calling sum on an array of ints?
	scores[cat] = get_score(last_dice_vals, cat)
	score_category_claimed.emit()
	
	# Update the totals displayed on the score sheet since they may have 
	# changed
	update_score_totals()
	
	
	
	pass # Replace with function body.


func _ready():
	# Connecting all buttons to the "_on_btn_pressed" method
	btn_three_of_a_kind.pressed.connect(func(): _on_btn_pressed(btn_three_of_a_kind))
	btn_four_of_a_kind.pressed.connect(func(): _on_btn_pressed(btn_four_of_a_kind))
	btn_score_aces.pressed.connect(func(): _on_btn_pressed(btn_score_aces))
	btn_score_twos.pressed.connect(func(): _on_btn_pressed(btn_score_twos))
	btn_score_threes.pressed.connect(func(): _on_btn_pressed(btn_score_threes))
	btn_score_fours.pressed.connect(func(): _on_btn_pressed(btn_score_fours))
	btn_score_fives.pressed.connect(func(): _on_btn_pressed(btn_score_fives))
	btn_score_sixes.pressed.connect(func(): _on_btn_pressed(btn_score_sixes))
	btn_three_of_a_kind.pressed.connect(func(): _on_btn_pressed(btn_three_of_a_kind))
	btn_four_of_a_kind.pressed.connect(func(): _on_btn_pressed(btn_four_of_a_kind))
	btn_full_house.pressed.connect(func(): _on_btn_pressed(btn_full_house))
	btn_small_straight.pressed.connect(func(): _on_btn_pressed(btn_small_straight))
	btn_large_straight.pressed.connect(func(): _on_btn_pressed(btn_large_straight))
	btn_yahtzee.pressed.connect(func(): _on_btn_pressed(btn_yahtzee))
	btn_chance.pressed.connect(func(): _on_btn_pressed(btn_chance))
