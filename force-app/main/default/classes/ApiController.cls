public without sharing class ApiController {

    @AuraEnabled
    public static String callExternalApi() {
    try {
        // Create HTTP request
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://jsonplaceholder.typicode.com/posts/1'); // Example API
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        request.setTimeout(30000); // 30 seconds timeout
        // Make the callout
        Http http = new Http();
        HttpResponse response = http.send(request);
        
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                firePlatformEvent('Success', 'API call completed successfully', responseBody);
                return responseBody;
            } else {
                String errorMessage = 'API call failed with status: ' + response.getStatusCode() + ' - ' + response.getBody();
                firePlatformEvent('Error', errorMessage, null);
                throw new CalloutException(errorMessage);
            }
    } catch (Exception e) {
        String errorMessage = 'Exception during API call: ' + e.getMessage();
        firePlatformEvent('Error', errorMessage, null);
        throw new AuraHandledException(errorMessage);
    }
    }


    private static void firePlatformEvent(String status, String message, String data) {
    
        API_Response__e platformEvent = new API_Response__e(
            Status__c = status,
            Message__c = message,
            Data__c = data,
            Timestamp__c = System.now()
        );
    
        Database.SaveResult result = EventBus.publish(platformEvent);
        if (!result.isSuccess()) {
            System.debug('Failed to publish platform event: ' + result.getErrors());
        }
    }


    @AuraEnabled
    public static String postToExternalApi(String jsonPayload) {
        try {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://jsonplaceholder.typicode.com/posts');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setBody(jsonPayload);
            request.setTimeout(30000);
            Http http = new Http();
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 201) {
                String responseBody = response.getBody();
                firePlatformEvent('Success', 'POST request completed successfully', responseBody);
                return responseBody;
            } else {
                String errorMessage = 'POST request failed with status: ' + response.getStatusCode();
                firePlatformEvent('Error', errorMessage, null);
                throw new CalloutException(errorMessage);
            }
        }catch (Exception e) {
            String errorMessage = 'Exception during POST request: ' + e.getMessage();
            firePlatformEvent('Error', errorMessage, null);
            throw new AuraHandledException(errorMessage);
        }
    }
}