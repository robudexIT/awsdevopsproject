exports.handler = (event, context, callback) => {
  const command = event.command
  const status = process.env.ENV_STATUS
  
  
  if( command  === 'run'){
      callback(null, {status: 'InProgress', executionId: 'abcd12345', attempt:3})
  }else if(command === 'status'){
       if(status === 'Success'){
         callback(null, {status: 'Success', executionId: 'abcd12345'})
       }else if(status === 'Failed'){
          callback(null,{status: 'Failed', executionId: 'abcd12345'})
       }else{
         console.log(event)
         let attempt = parseInt(event.lambdaResult.attempt)
         if(attempt === 0){
           callback(null, {status: 'Failed', executionId: 'abcd12345'})
         }else{
           attempt = attempt - 1
           callback(null, {status: 'InProgress', executionId: 'abcd12345', attempt:attempt})
         }
       }
       
  }
};
