public class ProcessRegister {

    public static void registerService() {

        // WebStore query values
        String webstoreName = 'AppsStore';

        // Apex Class query values
        String apexClassName = 'ShippingCartCalculatorSample';
        String status = 'Active';
        Double apiVersion = 54.0;

        // RegisteredExternalService values
        String registeredProviderType = 'Extension';
        String registeredDevName = 'Admin_Delivery';
        String registeredLabel = registeredDevName;

        // StoreIntegratedService values
        String devName = registeredDevName;
        String prefix = registeredProviderType;
        String prefixedName = prefix + '__' + devName;

        // Locate WebStore
        WebStore webStore = [
            SELECT Id 
            FROM WebStore 
            WHERE Name = :webstoreName 
            LIMIT 1
        ];

        String webStoreId = webStore.Id;
        System.debug('webStoreId: ' + webStoreId);

        // Locate Apex Class
        ApexClass apexClassRec = [
            SELECT Id 
            FROM ApexClass 
            WHERE Status = :status 
            AND ApiVersion = :apiVersion 
            AND Name = :apexClassName 
            LIMIT 1
        ];

        String apexClassId = apexClassRec.Id;
        System.debug('apexClassId: ' + apexClassId);

        // Locate Apex in RegisteredExternalService
        String registeredIntegrationId = null;

        try {

            RegisteredExternalService res = [
                SELECT Id 
                FROM RegisteredExternalService
                WHERE ExternalServiceProviderId = :apexClassId
                AND DeveloperName = :registeredDevName
                AND ExternalServiceProviderType = :registeredProviderType
                LIMIT 1
            ];

            registeredIntegrationId = res.Id;
            System.debug('apexclassregistration: FOUND ' + registeredIntegrationId);

        } 
        catch (QueryException q) {

            System.debug('apexclassregistration: MISSING ' + apexClassId);

            RegisteredExternalService newService = new RegisteredExternalService();
            newService.DeveloperName = registeredDevName;
            newService.MasterLabel = registeredLabel;
            newService.ExternalServiceProviderId = apexClassId;
            newService.ExternalServiceProviderType = registeredProviderType;

            insert newService;

            RegisteredExternalService res = [
                SELECT Id 
                FROM RegisteredExternalService
                WHERE ExternalServiceProviderId = :apexClassId
                LIMIT 1
            ];

            registeredIntegrationId = res.Id;
            System.debug('apexclassregistration: INSERTED ' + registeredIntegrationId);
        }
    }
}