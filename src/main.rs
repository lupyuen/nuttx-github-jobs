use std::io::BufReader;
use std::fs::{File, read_to_string};
#[allow(non_snake_case)]

fn main() {
    // Read a Job JSON
    const JOB_ID: u64 = 20304392258;
    let file = File::open(format!("job/{}.json", JOB_ID)).unwrap();
    let reader = BufReader::new(file);
    let job: serde_json::Value = serde_json::from_reader(reader).unwrap();
    println!("\njob=\n{}", serde_json::to_string_pretty(&job).unwrap());

    // Read a Job Duration
    let duration = read_to_string(format!("duration/{}.txt", JOB_ID)).unwrap();
    println!("\njob_duration={}", duration);

    // Update the Job JSON with the duration
    let mut job_with_duration = job.clone();
    job_with_duration["run_duration_ms"] = serde_json::Value::String(duration.trim().to_string());
    println!("\njob_with_duration=\n{}", serde_json::to_string_pretty(&job_with_duration).unwrap());

    // Dump the Job Fields
    for field in JOB_FIELDS.iter() {
        println!("job_{}={}", field, job_with_duration[field]);
    }

    // Read a PR JSON
    const PR_NUMBER: u32 = 17538;
    let file = File::open(format!("pr/{}.json", PR_NUMBER)).unwrap();
    let reader = BufReader::new(file);
    let pr: serde_json::Value = serde_json::from_reader(reader).unwrap();
    println!("\npr=\n{}", serde_json::to_string_pretty(&pr).unwrap());

    // Flatten the labels into "Arch: arm, Size: M"
    let mut labels_str = String::new();
    if let Some(labels) = pr["labels"].as_array() {
        for (i, label) in labels.iter().enumerate() {
            println!("pr_label_{}={}", i, label["name"]);
            if let Some(name) = label["name"].as_str() {
                if !labels_str.is_empty() {
                    labels_str.push_str(", ");
                }
                labels_str.push_str(name);
            }
        }
    }

    // Extract the Login from author, headRepositoryOwner, mergedBy fields
    let author = pr["author"]["login"].as_str().unwrap_or("");
    let headRepository = pr["headRepository"]["name"].as_str().unwrap_or("");
    let headRepositoryOwner = pr["headRepositoryOwner"]["login"].as_str().unwrap_or("");
    let mergeCommit = pr["mergeCommit"]["oid"].as_str().unwrap_or("");
    let mergedBy = pr["mergedBy"]["login"].as_str().unwrap_or("");

    // Update the PR JSON with the flattened labels and extracted logins
    let mut pr_with_labels = pr.clone();
    pr_with_labels["labels"] = serde_json::Value::String(labels_str);
    pr_with_labels["author"] = serde_json::Value::String(author.to_string());
    pr_with_labels["headRepository"] = serde_json::Value::String(headRepository.to_string());
    pr_with_labels["headRepositoryOwner"] = serde_json::Value::String(headRepositoryOwner.to_string());
    pr_with_labels["mergeCommit"] = serde_json::Value::String(mergeCommit.to_string());
    pr_with_labels["mergedBy"] = serde_json::Value::String(mergedBy.to_string());
    println!("\npr_with_labels=\n{}", serde_json::to_string_pretty(&pr_with_labels).unwrap());

    // Dump the PR Fields
    for field in PR_FIELDS.iter() {
        println!("pr_{}={}", field, pr_with_labels[field]);
    }
}

// PR Fields: id,url,updatedAt,title,additions,assignees,author,autoMergeRequest,baseRefName,changedFiles,closed,closedAt,createdAt,deletions,files,headRefName,headRefOid,headRepository,headRepositoryOwner,isDraft,labels,mergeCommit,mergeStateStatus,mergeable,mergedAt,mergedBy,milestone,number,state
const PR_FIELDS: [&'static str; 28] = [
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
const JOB_FIELDS: [&'static str; 16] = [
    "conclusion", 
    "createdAt", 
    "databaseId", 
    "displayTitle", 
    "event", 
    "headBranch", 
    "headSha", 
    "name", 
    "number", 
    "run_duration_ms",
    "startedAt", 
    "status", 
    "updatedAt", 
    "url", 
    "workflowDatabaseId", 
    "workflowName"    
];
