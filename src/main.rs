use std::io::BufReader;
use std::fs::File;

fn main() {
    let file = File::open("job/22874413924.json").unwrap();
    let reader = BufReader::new(file);
    let job: serde_json::Value = serde_json::from_reader(reader).unwrap();
    println!("\njob=\n{}", serde_json::to_string_pretty(&job).unwrap());
}

// PR: id,url,updatedAt,title,additions,assignees,author,autoMergeRequest,baseRefName,changedFiles,closed,closedAt,createdAt,deletions,files,headRefName,headRefOid,headRepository,headRepositoryOwner,isDraft,labels,mergeCommit,mergeStateStatus,mergeable,mergedAt,mergedBy,milestone,number,state
// Job: conclusion,createdAt,databaseId,displayTitle,event,headBranch,headSha,name,number,startedAt,status,updatedAt,url,workflowDatabaseId,workflowName
