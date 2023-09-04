# comment
variable "bucket-to-drift-id" {
    description = "The id of the bucket to add tag to"
    type = string
}

variable "region" {
    description = "Region where to create resources" 
    type = string
    default = "eu-west-1"
}


