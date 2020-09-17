# Cloud Front

## Cloud Formation テンプレート
* S3
* Cloud Front
* WAF

> ⚠️ **Warn**: バージニア北部(us-east-1)以外ではスタック作成不可。(CloudFrontがバージニア北部のみ対応しているため)

---

## AWS S3
### パラメータ

| 変数 | 日本語名 | 備考 |
| :---| :---: | :---: |
| `ENV` | 環境名 ||
| `ServiceName` | サービス名 ||

### デプロイ

<details>
  <summary>CLI Command</summary>
  <div>

  ```
  aws cloudformation deploy \
  --stack-name ${スタック名} \
  --template-file 01_s3Bucket.yml \
  --region "us-east-1" \
  --parameter-overrides \
    ENV={ENV} \
    ServiceName=${サービス名}
  ```

  e.g.

  ```
  aws cloudformation deploy \
  --stack-name pvs-stg-cf-bucket \
  --template-file 01_s3Bucket.yml \
  --region "us-east-1" \
  --parameter-overrides \
    ENV=stg \
    ServiceName=pvs
  ```

  </div>
</details>

---

## AWS Cloud Front
### パラメータ

| 変数 | 日本語名 | 備考 |
| :---| :---: | :---: |
| `ENV` | 環境名 ||
| `ServiceName` | サービス名 ||
| `SystemName` | システム名 ||
| `CustomerName` | 事業者名 ||
| `SSLArn` | ACM SSL証明書 ARN ||
| `ALBDomainName` | ALB DNS名 |必須|
| `DistributionDomainName` | CloudFront CNAMEドメイン |省略可|
| `AttachWebACL` | WAF WebACLのアタッチ | true -> WebACLを使用する, false -> WebACLを使用しない ※ENV＝prodの場合はtrueでも使用しない |

> ℹ︎ **Info**: 東京リージョンのOutputは参照できないため、パラメータとして渡す必要がある。

### デプロイ

<details>
  <summary>CLI Command</summary>
  <div>

  ```
  aws cloudformation deploy \
  --stack-name ${スタック名} \
  --template-file 02_cloudfront.yml \
  --region "us-east-1" \
  --parameter-overrides \
    ENV={環境名} \
    ServiceName={サービス名} \
    SystemName={システム名} \
    CustomerName={事業者名} \
    SSLArn={ACM SSL証明書 ARN} \
    ALBDomainName={ALB DNS名} \
    DistributionDomainName={CNAMEドメイン} \
    AttachWebACL={ WebACLの使用(true or false)}
  ```

  e.g.
  ```
  aws cloudformation deploy \
  --stack-name pvs-stg-web-cf \
  --template-file 02_cloudfront.yml \
  --region "us-east-1" \
  --parameter-overrides \
    ENV=stg \
    ServiceName=pvs \
    SystemName=web \
    CustomerName=tipness \
    SSLArn=arn:aws:acm:us-east-1:845168618390:certificate/cc73e8da-4e30-48a2-8c4f-5e1cb36aec09
    ALBDomainName=tipness-web-stg-alb-62669408.ap-northeast-1.elb.amazonaws.com	 \
    DistributionDomainName=tipness.stores.play.jp  \
    AttachWebACL=false
  ```

    </div>
</details>

---

## AWS WAF
### パラメータ

| 変数 | 日本語名 | 備考 |
| :---| :---: | :---: |
| `ENV` | 環境名 ||
| `ServiceName` | サービス名 ||
| `SystemName` | システム名 ||
| `CustomerName` | 事業者名 ||

### デプロイ

<details>
  <summary>CLI Command</summary>
  <div>

  ```
  aws cloudformation deploy \
  --stack-name ${スタック名} \
  --template-file waf.yml \
  --region "us-east-1" \
  --parameter-overrides \
    ENV={ENV} \
    ServiceName={サービス名} \
    SystemName={システム名} \
    CustomerName={事業者名}
  ```

  e.g.
  ```
  aws cloudformation deploy \
  --stack-name pvs-stg-tipness-waf \
  --template-file waf.yml \
  --region "us-east-1" \
  --parameter-overrides \
    ENV=stg \
    ServiceName=pvs \
    SystemName=web \
    CustomerName=tipness
  ```

  </div>
</details>