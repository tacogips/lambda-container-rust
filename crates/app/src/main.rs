mod handler;
use lambda_runtime::service_fn;

type Error = Box<dyn std::error::Error + Sync + Send + 'static>;

#[tokio::main]
async fn main() -> Result<(), Error> {
    println!("Start lambda...");
    lambda_runtime::run(service_fn(handler::handler)).await?;
    Ok(())
}
