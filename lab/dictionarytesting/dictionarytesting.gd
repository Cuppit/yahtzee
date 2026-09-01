extends Node

var somedict = {"apple": 0, "banana": 1}

func _ready():
	for item in somedict:
		print("The key is going to be: ",str(item),".  The value is going to be: ",str(somedict[item]))
		print("type of key is: ",typeof(item), "The type of its val is: ",typeof(somedict[item]))

		
	
