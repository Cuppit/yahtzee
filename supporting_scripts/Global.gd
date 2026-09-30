extends Node
var random = RandomNumberGenerator.new()
var rand_num_rng_1_to_6 = []
func _ready():
	# Generate starting pool of values
	for x in range(6):
		rand_num_rng_1_to_6.append(random.randi_range(1,6))
	print("GLOBAL SCRIPT PRINT STATEMENT")
	print("Starting random num pool: ",rand_num_rng_1_to_6)
	
func get_custom_rand_num_1_thru_6():
	rand_num_rng_1_to_6.push_front(randi_range(1,6))
	return rand_num_rng_1_to_6.pop_back()
