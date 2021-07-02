## Task#7: Optional homework (AWS CLI). Deadline - 12/07/2021

### Write a script in bash/powershell using either aws cli or powershell:
1. Collect the list of EBS SnapshotIDs and the corresponding StartTime value.
2. Show a list of snapshots older than N days/hours/minutes (as it is more convenient for testing) and their size.
3. Additionally, you can add the option to filter snapshots by Tag: Value using the parameter and display the same information.
4. Additionally add the option to fill the selected snapshots into s3.
5. You can come up with your own use case.

### Implementation...
1. Unstalling the AWS CLI VERSION 2 on Linux by link (https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html) 

Usaged commands:
1. aws ec2 describe-snapshots \
    --owner-ids self \
    --query "Snapshots[*].{ID:SnapshotId,Time:StartTime}"

2. aws ec2 describe-snapshots \
    --owner-ids self \
    --filters Name=status,Values=completed \
    --query "Snapshots[*].{ID:SnapshotId,Time:StartTime}"

3. aws ec2 describe-snapshots \
    --filters Name=tag:Name,Values=Go_app_Snapshot

4. aws copy-snapshot \
    --source-snapshot-name snap-057f5fc26b5f5c36c \
    --target-snapshot-name snap-057f5fc26b5f5c36c-copy \
    --target-bucket mr-snapshot-archive

Ex. aws s3api list-buckets

aws ec2 copy-snapshot \
    --source-region us-east-1 \
    --source-snapshot-id snap-057f5fc26b5f5c36c \
    --destination-outpost-arn aws:s3:::mr-snapshot-archive \
    --description "This is my copied snapshot."