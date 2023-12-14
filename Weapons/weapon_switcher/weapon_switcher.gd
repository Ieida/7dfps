extends Node
class_name WeaponSwitcher


var weapons: Dictionary
var current_weapon: Weapon = null


func add_weapon(name: String, weapon: Weapon):
	weapons[name] = weapon


func remove_weapon(name: String):
	weapons.erase(name)


func switch_to(name: String):
	if not weapons.has(name): return current_weapon
	var new_weapon = weapons[name]
	if not new_weapon or new_weapon == current_weapon: return current_weapon
	
	# Holster
	if current_weapon:
		await current_weapon.holster()
		
	# Unholster
	await new_weapon.unholster()
	current_weapon = new_weapon
	
	# Return the newly unholstered weapon for the method caller to use
	return new_weapon
