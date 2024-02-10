resource "aws_dynamodb_table" "cat_facts" {
  name           = "CatFacts"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "FactID"

  attribute {
    name = "FactID"
    type = "S"
  }
}