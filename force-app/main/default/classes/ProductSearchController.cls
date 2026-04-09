public without sharing class ProductSearchController {
    @AuraEnabled
    public static ConnectApi.ProductSearchResults getProductSerachResults(String searchTrm){
        
        String webstoreId = '0ZEdL0000036F5tWAE';
        String effectiveAccountId = '001dL00001wp9ddQAA';

        ConnectApi.ProductSearchInput productSearchInput = new ConnectApi.ProductSearchInput();
        productSearchInput.searchTerm = searchTrm;

        ConnectApi.ProductSearchResults results =
            ConnectApi.CommerceSearch.searchProducts(webstoreId, effectiveAccountId, productSearchInput);

        System.debug('result ...' + JSON.serialize(results));
        return results;
    }
}