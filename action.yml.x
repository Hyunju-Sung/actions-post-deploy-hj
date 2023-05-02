# ecr-login/action.yml
name: 'post actions'
description: 'post actions'

inputs:
  job-name:
    description: "actions(job) name"
    required: true
  job-status:
    description: "actions(job) status"
    required: true
  slack_webhook_url:
    description: "slack_webhook_url"
    required: true
outputs:
  current-job-name:
    description: "The URI of the ECR Private or ECR Public registry."
    value: ${{ env.ECR_REGISTRY }}
  current-job-status:
    description: "The URI of the ECR Private or ECR Public registry."
    value: ${{ env.ECR_REGISTRY }}

runs:
  using: 'composite'
  steps:
    - name: set state
      env:
        ECR_REGISTRY: ${{ inputs.job-name }}
      run: |
        echo "CURRENT-JOB-NAME=${{ inputs.job-name }}" >> $GITHUB_ENV
        echo "CURRENT-JOB-STATUS=${{ inputs.job-status }}" >> $GITHUB_ENV
      shell: bash

    - name: clear stg git tag
      run: |
        echo "clear stg git tag, because stg flow fail"
      shell: bash

    - uses: 8398a7/action-slack@v3
      with:
        status: ${{ inputs.job-status }}
        fields: repo,message,commit,author,action,eventName,ref,workflow,job,took,pullRequest # selectable (default: repo,message)
      env:
        SLACK_WEBHOOK_URL: ${{ inputs.slack_webhook_url }} # required
      if: env.CURRENT-JOB-STATUS == 'failure' # Pick up events even if the job fails or is canceled.
