use lambda_runtime::LambdaEvent;

use crate::Error;

#[derive(serde::Deserialize, Clone, Debug)]
#[allow(non_snake_case)]
pub struct Message {
    pub Records: Vec<Record>,
}

#[derive(serde::Deserialize, Clone, Debug)]
pub struct Record {
    pub body: String,
}

// lambda receive the following body
//
//{
// "Records":[
//      {
//        "body":"this is a test"
//      },
//      {
//        "body":"this is a test2"
//      }
// ]
//}

pub async fn handler(e: LambdaEvent<Message>) -> Result<(), Error> {
    for (i, record) in e.payload.Records.into_iter().enumerate() {
        println!(" mod for container Record: {}: {:?}", i, record);
    }
    Ok(())
}
