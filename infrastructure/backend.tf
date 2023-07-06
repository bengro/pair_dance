terraform {
  backend "gcs" {
    bucket = "pair-dance-tfstate"
    prefix = "1"
  }
}
