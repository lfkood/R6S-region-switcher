extends Control

var regions = ["default",
"playfab/australiaeast",
"playfab/brazilsouth",
"playfab/centralus",
"playfab/eastasia",
"playfab/eastus",
"playfab/japaneast",
"playfab/northeurope",
"playfab/southafricanorth",
"playfab/southcentralus",
"playfab/southeastasia",
"playfab/uaenorth",
"playfab/westeurope",
"playfab/westus"]

var path = ""
var ini_string = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in regions.size() - 1:
		$SelectAServer/RegionSelect.add_item(regions[x + 1])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func check_if_correct_file_path(path):
	return true

# Straight from the godot docs
func save_file(content):
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(content)

# Straight from the godot docs
func load_file():
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	return content


func _on_button_pressed():
	$ErrorPanel.hide()
	if !FileAccess.file_exists(path):
		$ErrorPanel.show()
		return 0
	write_region()


func write_region():
	var regex_pattern = RegEx.new()
	regex_pattern.compile("\nDataCenterHint=(.+)\n")
	save_file(regex_pattern.sub(ini_string,"\nDataCenterHint=" + regions[$SelectAServer/RegionSelect.get_selected()] + "\n"))
	$SelectAServer/Curry.set_text("Currently: " + regions[$SelectAServer/RegionSelect.get_selected()])


func _on_line_edit_text_submitted(new_path):
	path = new_path
	$ErrorPanel.hide()
	if !FileAccess.file_exists(path):
		$ErrorPanel.show()
		return 0
	ini_string = load_file()
	var regex_pattern = RegEx.new()
	regex_pattern.compile("\nDataCenterHint=(.+)\n")
	var search = regex_pattern.search(ini_string)
	$SelectAServer/Curry.set_text("Currently: " + search.get_string(1))
