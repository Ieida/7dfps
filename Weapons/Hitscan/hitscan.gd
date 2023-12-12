extends Weapon


func use():
	shoot()


func shoot():
	print("%s shooting %s" % [owner, self])
