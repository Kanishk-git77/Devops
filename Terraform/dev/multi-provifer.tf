resource "local_file" "pet_name" {
	    filename = "/Users/kanishqk77/Desktop/DevOps/Terraform/dev/pets.txt"
		content = "My favourite pet is ${random_pet.my-pet.id}"
}

resource "random_pet" "my-pet" {
	      prefix = "Mrs"
	      separator = "."
	      length = "1"
}