
# COS Credentials
variable "api_key" {
  type        = string
  description = "api key of the COS bucket"
}
variable "cos_crn" {
  type        = string
  description = "COS instance CRN"
}
variable "endpoint" {
  type        = string
  description = "COS endpoint"
}
variable "bucket_name" {
  type        = string
  description = "COS bucket name"
}
# Input Json file
variable "input_file_name" {
  type        = string
  description = "Input json file name that is present in the cos-bucket or in the local"
}