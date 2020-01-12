#List aws ami 
aws ec2 describe-images --filters "Name=owner-id,Values=099720109477"