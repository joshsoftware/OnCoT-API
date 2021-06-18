# frozen_string_literal: true

aws_credentials = Aws::Credentials.new(
  ENV['AWS_ACCESS_KEY_ID'],
  ENV['AWS_SECRET_ACCESS_KEY']
)

S3_BUCKET = Aws::S3::Resource.new(
  region: ENV['AWS_REGION'],
  credentials: aws_credentials
).bucket('oncot')
