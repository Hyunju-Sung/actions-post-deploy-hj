# ecr-login/action.yml
name: 'post actions'
description: 'post actions'

inputs:
  workflow-job-name:
    description: "actions(job) name"
    required: true
  workflow-job-status:
    description: "actions(job) status"
    required: true
  tag:
    description: "delete git tag"
    required: true
  trigger-delete-git-tag:
    default: false
    description: "delete git tag"
    required: true
  slack_webhook_url:
    description: "slack_webhook_url"
    required: true
  github-token:
    description: "github-token"
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
    - name: Checkout repository
      uses: actions/checkout@v3
      with:
        fetch-depth: 0
        token: ${{ inputs.github-token }}
    - name: delete git tag
      if: ${{ inputs.trigger-delete-git-tag }} == true
      run: |
        git tag -d ${{ inputs.tag }}
        git push --delete origin ${{ inputs.tag }}
      shell: bash

    - name: Send Slack
      uses: 8398a7/action-slack@v3
      with:
        job_name: ${{ inputs.workflow-job-name }}
        status: ${{ inputs.workflow-job-status }}
        fields: repo,message,commit,author,action,eventName,ref,workflow,job,took,pullRequest # selectable (default: repo,message)
      env:
        SLACK_WEBHOOK_URL: ${{ inputs.slack_webhook_url }} # required