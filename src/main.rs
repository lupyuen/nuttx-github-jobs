use std::io::BufReader;
use std::fs::{File, read_to_string};

fn main() {
    // Read a Job JSON
    let file = File::open("job/22874413924.json").unwrap();
    let reader = BufReader::new(file);
    let job: serde_json::Value = serde_json::from_reader(reader).unwrap();
    println!("\njob=\n{}", serde_json::to_string_pretty(&job).unwrap());

    for field in JOB_FIELDS.iter() {
        println!("job_{}={}", field, job[field]);
    }

    // Read a PR JSON
    let file = File::open("pr/18511.json").unwrap();
    let reader = BufReader::new(file);
    let pr: serde_json::Value = serde_json::from_reader(reader).unwrap();
    println!("\npr=\n{}", serde_json::to_string_pretty(&pr).unwrap());

    for field in PR_FIELDS.iter() {
        println!("pr_{}={}", field, pr[field]);
    }

    // Read a Job Duration
    let duration = read_to_string("duration/20994614931.txt").unwrap();
    println!("\njob_duration={}", duration);
}

// PR Fields: id,url,updatedAt,title,additions,assignees,author,autoMergeRequest,baseRefName,changedFiles,closed,closedAt,createdAt,deletions,files,headRefName,headRefOid,headRepository,headRepositoryOwner,isDraft,labels,mergeCommit,mergeStateStatus,mergeable,mergedAt,mergedBy,milestone,number,state
const PR_FIELDS: [&'static str; 29] = [
    "id",
    "url",
    "updatedAt",
    "title",
    "additions",
    "assignees",
    "author",
    "autoMergeRequest",
    "baseRefName",
    "changedFiles",
    "closed",
    "closedAt",
    "createdAt",
    "deletions",
    "files",
    "headRefName",
    "headRefOid",
    "headRepository",
    "headRepositoryOwner",
    "isDraft",
    "labels",
    "mergeCommit",
    "mergeStateStatus",
    "mergeable",
    "mergedAt",
    "mergedBy",
    "milestone",
    "number",
    "state"
];

// Job Fields: conclusion,createdAt,databaseId,displayTitle,event,headBranch,headSha,name,number,startedAt,status,updatedAt,url,workflowDatabaseId,workflowName
const JOB_FIELDS: [&'static str; 15] = [
    "conclusion", 
    "createdAt", 
    "databaseId", 
    "displayTitle", 
    "event", 
    "headBranch", 
    "headSha", 
    "name", 
    "number", 
    "startedAt", 
    "status", 
    "updatedAt", 
    "url", 
    "workflowDatabaseId", 
    "workflowName"    
];
