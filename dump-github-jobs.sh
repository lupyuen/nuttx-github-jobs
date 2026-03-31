#!/usr/bin/env bash
## Dump all the GitHub Actions Jobs

## Set the GitHub Token: export GITHUB_TOKEN=...
## Any Token with Read-Access to NuttX Repo will do:
## "public_repo" (Access public repositories)
. $HOME/github-token.sh

## First Parameter is Number of Days to Backtrack (e.g. 365)
num_days=$1
if [[ "$num_days" == "" ]]; then
  echo "ERROR: Number of Days Parameter is missing (e.g. 365)"
  exit 1
fi

## Dump the GitHub PRs into pr/$pr_num.json
function dump_pr_list {
  local user=$1
  local repo=$2
  local date=$3
  local pr_list=$(
    gh pr list \
      --repo $user/$repo \
      --limit 1000 \
      --state all \
      --search "created:$date" \
      --json id,url,updatedAt,title,additions,assignees,author,autoMergeRequest,baseRefName,changedFiles,closed,closedAt,createdAt,deletions,files,headRefName,headRefOid,headRepository,headRepositoryOwner,isDraft,labels,mergeCommit,mergeStateStatus,mergeable,mergedAt,mergedBy,milestone,number,state \
      | jq
  )

  local len=$( echo "$pr_list" | jq '. | length' )
  echo "Got $len PRs"
  for (( i=0; i<$len; i++ )) ; do
    local pr=$(echo "$pr_list" | jq ".[$i]")
    local pr_num=$(echo "$pr" | jq .number)
    local file=pr/$pr_num.json
    echo "$pr" | jq >$file
    echo "PR $i: $file"
  done
}

## Result
# [
#   {
#     "additions": 1320,
#     "assignees": [],
#     "author": {
#       "id": "MDQ6VXNlcjY1MzIwMjg=",
#       "is_bot": false,
#       "login": "jasonbu",
#       "name": ""
#     },
#     "autoMergeRequest": null,
#     "baseRefName": "master",
#     "changedFiles": 20,
#     "closed": false,
#     "closedAt": null,
#     "createdAt": "2026-03-06T10:01:56Z",
#     "deletions": 24,
#     "files": [
#       {
#         "path": "arch/arm/include/imx9/imx95_irq.h",
#         "additions": 3,
#         "deletions": 3
#       },
#       {
#         "path": "arch/arm64/include/imx9/imx95_irq.h",
#         "additions": 3,
#         "deletions": 3
#       },
#       {
#         "path": "arch/arm64/src/common/CMakeLists.txt",
#         "additions": 1,
#         "deletions": 0
#       },
#       {
#         "path": "arch/arm64/src/imx9/CMakeLists.txt",
#         "additions": 3,
#         "deletions": 1
#       },
#       {
#         "path": "arch/arm64/src/imx9/Kconfig",
#         "additions": 3,
#         "deletions": 0
#       },
#       {
#         "path": "arch/arm64/src/imx9/hardware/imx95/imx95_ccm.h",
#         "additions": 753,
#         "deletions": 0
#       },
#       {
#         "path": "arch/arm64/src/imx9/hardware/imx95/imx95_gpio.h",
#         "additions": 61,
#         "deletions": 0
#       },
#       {
#         "path": "arch/arm64/src/imx9/hardware/imx95/imx95_pinmux.h",
#         "additions": 50,
#         "deletions": 0
#       },
#       {
#         "path": "arch/arm64/src/imx9/hardware/imx95/imx95_pll.h",
#         "additions": 197,
#         "deletions": 0
#       },
#       {
#         "path": "arch/arm64/src/imx9/hardware/imx9_ccm.h",
#         "additions": 1,
#         "deletions": 0
#       },
#       {
#         "path": "arch/arm64/src/imx9/hardware/imx9_gpio.h",
#         "additions": 1,
#         "deletions": 0
#       },
#       {
#         "path": "arch/arm64/src/imx9/hardware/imx9_pinmux.h",
#         "additions": 1,
#         "deletions": 0
#       },
#       {
#         "path": "arch/arm64/src/imx9/imx9_gpiobase.c",
#         "additions": 1,
#         "deletions": 2
#       },
#       {
#         "path": "arch/arm64/src/imx9/imx9_usdhc.c",
#         "additions": 63,
#         "deletions": 6
#       },
#       {
#         "path": "boards/arm64/imx9/imx95-a55-evk/include/board.h",
#         "additions": 24,
#         "deletions": 3
#       },
#       {
#         "path": "boards/arm64/imx9/imx95-a55-evk/src/CMakeLists.txt",
#         "additions": 4,
#         "deletions": 0
#       },
#       {
#         "path": "boards/arm64/imx9/imx95-a55-evk/src/Makefile",
#         "additions": 4,
#         "deletions": 0
#       },
#       {
#         "path": "boards/arm64/imx9/imx95-a55-evk/src/imx9_bringup.c",
#         "additions": 48,
#         "deletions": 0
#       },
#       {
#         "path": "boards/arm64/imx9/imx95-a55-evk/src/imx9_usdhc.c",
#         "additions": 85,
#         "deletions": 0
#       },
#       {
#         "path": "drivers/mmcsd/mmcsd_sdio.c",
#         "additions": 14,
#         "deletions": 6
#       }
#     ],
#     "headRefName": "imx95_emmc8bit",
#     "headRefOid": "95d44356ea31a03c76208790987d05da674abe1c",
#     "headRepository": {
#       "id": "R_kgDOLHs-vw",
#       "name": "nuttx"
#     },
#     "headRepositoryOwner": {
#       "id": "MDQ6VXNlcjY1MzIwMjg=",
#       "login": "jasonbu"
#     },
#     "id": "PR_kwDODZiUac7IdLQM",
#     "isDraft": false,
#     "labels": [
#       {
#         "id": "LA_kwDODZiUac8AAAABsqOt8A",
#         "name": "Arch: arm",
#         "description": "Issues related to ARM (32-bit) architecture",
#         "color": "DC5544"
#       },
#       {
#         "id": "LA_kwDODZiUac8AAAABsqO1YA",
#         "name": "Arch: arm64",
#         "description": "Issues related to ARM64 (64-bit) architecture",
#         "color": "DC5544"
#       },
#       {
#         "id": "LA_kwDODZiUac8AAAABsqR34A",
#         "name": "Area: Drivers",
#         "description": "Drivers issues",
#         "color": "0075ca"
#       },
#       {
#         "id": "LA_kwDODZiUac8AAAABvj_dNA",
#         "name": "Size: XL",
#         "description": "The size of the change in this PR is very large. Consider breaking down the PR into smaller pieces.",
#         "color": "FEF2C0"
#       },
#       {
#         "id": "LA_kwDODZiUac8AAAABw8LvAA",
#         "name": "Board: arm64",
#         "description": "",
#         "color": "F9D0C4"
#       }
#     ],
#     "mergeCommit": null,
#     "mergeStateStatus": "CLEAN",
#     "mergeable": "MERGEABLE",
#     "mergedAt": null,
#     "mergedBy": null,
#     "milestone": null,
#     "number": 18501,
#     "state": "OPEN",
#     "title": "arch/arm64/imx95-a55: add GPIO and eMMC (USDHC) support with partition table parsing",
#     "updatedAt": "2026-03-09T08:57:41Z",
#     "url": "https://github.com/apache/nuttx/pull/18501"
#   }
# ]

## Dump the GitHub Jobs into job/$run_id.json
function dump_job_list {
  local user=$1
  local repo=$2
  local date=$3
  local job_list=$(
    gh run list \
      --repo $user/$repo \
      --limit 1000 \
      --created $date \
      --json conclusion,createdAt,databaseId,displayTitle,event,headBranch,headSha,name,number,startedAt,status,updatedAt,url,workflowDatabaseId,workflowName
  )

  local len=$( echo "$job_list" | jq '. | length' )
  echo "Got $len Jobs"
  for (( i=0; i<$len; i++ )) ; do
    local job=$(echo "$job_list" | jq ".[$i]")
    local run_id=$(echo "$job" | jq .databaseId)
    local file=job/$run_id.json
    echo "$job" | jq >$file
    echo "Job $i: $file"

    ## Dump the Job Duration
    dump_duration $user $repo $run_id

    ## If this is a Build Job: Download and Parse the GitHub Build Logs
    ## Search the Job JSON for: "name": "Build"
    grep '"name": "Build"' $file
    local not_found=$?
    if [[ "$not_found" == "0" ]]; then
      dump_build $user $repo $run_id
    fi
  done
}

## Result:
# "conclusion": "success",
# "createdAt": "2026-03-09T04:01:49Z",
# "databaseId": 22837803838,
# "displayTitle": "arch/arm64/imx95-a55: add GPIO and eMMC (USDHC) support with partition table parsing",
# "event": "pull_request",
# "headBranch": "imx95_emmc8bit",
# "headSha": "95d44356ea31a03c76208790987d05da674abe1c",
# "name": "Build",
# "number": 53875,
# "startedAt": "2026-03-09T04:01:49Z",
# "status": "completed",
# "updatedAt": "2026-03-09T07:34:48Z",
# "url": "https://github.com/apache/nuttx/actions/runs/22837803838",
# "workflowDatabaseId": 908549,
# "workflowName": "Build"

## Dump the GitHub Job Duration into duration/$run_id.txt
function dump_duration {
  local user=$1
  local repo=$2
  local run_id=$3
  set +x  ## Don't Echo commands
  local duration=$(
    curl -L --silent \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer $GITHUB_TOKEN" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      https://api.github.com/repos/$user/$repo/actions/runs/$run_id/timing \
      | jq '.run_duration_ms'
  )
  set -x  ## Echo commands
  local file=duration/$run_id.txt
  echo "$duration" >$file
  echo "Duration for $run_id: $file"
  sleep 1
}

## Result:
# 12779000

## Download and Parse the GitHub Build Logs into success/$run_id/*.json, warning/$run_id/*.json, error/$run_id/*.json
## ../parse-nuttx-builds/download-github-logs.sh apache nuttx 23653869993
function dump_build {
  local user=$1
  local repo=$2
  local run_id=$3
  pushd ../parse-nuttx-builds
  ./download-github-logs.sh $user $repo $run_id
  popd
  sleep 1
}

## Dump the PRs, Jobs and Durations for the NuttX Repo and NuttX Apps Repo
function dump_repo {
  ## Backtrack for the specified number of days
  for ((days=0; days<$num_days; days++)); do
    echo "days=$days"
    if [ "`uname`" == "Darwin" ]; then
      date=$(date -u -v-${days}d +"%Y-%m-%d")
    else
      current_date_seconds=$(date +%s)
      seconds_to_subtract=$((days * 86400)) # 86400 seconds in a day
      past_date_seconds=$((current_date_seconds - seconds_to_subtract))
      date=$(date -u -d "@$past_date_seconds" +"%Y-%m-%d")
    fi
    echo "date=$date"

    ## Dump the PRs, Jobs and Durations
    dump_pr_list  apache nuttx $date
    dump_job_list apache nuttx $date
    dump_pr_list  apache nuttx-apps $date
    dump_job_list apache nuttx-apps $date
    sleep 1
  done
}

## Dump the PRs, Jobs and Durations for the NuttX Repo and NuttX Apps Repo
dump_repo

## For Testing
# date=$(date -u +'%Y-%m-%d')
# run_id=22837803838 ## From databaseId
# user=apache
# repo=nuttx
