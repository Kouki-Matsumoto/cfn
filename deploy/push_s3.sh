#!/bin/bash

############################################################################
# Description
# sh depoy.sh <env>
############################################################################

readonly env=$1
readonly option=$2

AWS_ACCOUNT_ID="845168618390"

echo 'AWSアカウントチェック...'
if aws sts get-caller-identity| grep ${AWS_ACCOUNT_ID} > /dev/null ; then
    echo 'OK';
else
    echo 'NG'
    echo 'AWSアカウントを切り替えてから実行してください。'
    echo 'e.g. export AWS_PROFILE=<プロファイル名>'
    exit 1
fi


case "${env}" in
  "stg")
    echo "--- Start for staging ---"
    readonly bucket_name="pvs-${env}-cfn-templates-bucket"
    readonly branch_name="staging"
    ;;
  "prod")
    echo "--- Start for production ---"
    readonly bucket_name="pvs-${env}-cfn-templates-bucket"
    readonly branch_name="master"
    ;;
  *)
    echo "--- Error !! ---"
    echo "Please arg prod or stg ."
    false
    exit 2
esac


if [ $option = "dryrun" ]; then
  git checkout ${branch_name}
  git pull origin ${branch_name}

  echo "--- Start delete DryRun ---"
  exec=`aws s3 rm s3://${bucket_name}/ --recursive --dryrun`
  echo ${exec}
  echo "--- End delete DryRun ---"

  echo "--- Start upload DryRun ---"
  exec=`aws s3 sync templates/ s3://${bucket_name}/ --exclude "*.md" --exclude "*.git*" --dryrun`
  echo ${exec}
  echo "--- End upload DryRun ---"
else
  git checkout ${branch_name}
  git pull origin ${branch_name}

  echo "--- Start delete ---"
  exec=`aws s3 rm s3://${bucket_name}/ --recursive`
  echo ${exec}
  echo "--- End delete ---"

  echo "--- Start upload ---"
  exec=`aws s3 sync templates/ s3://${bucket_name}/ --exclude "*.md" --exclude "*.git*" `
  echo ${exec}
  echo "--- End upload ---"
fi
