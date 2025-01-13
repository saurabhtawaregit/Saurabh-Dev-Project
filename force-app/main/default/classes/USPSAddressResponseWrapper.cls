public class USPSAddressResponseWrapper {
        @AuraEnabled public String firm;
        @AuraEnabled public Address address;
        @AuraEnabled public AdditionalInfo additionalInfo;
        @AuraEnabled public String corrections;
        @AuraEnabled public String matches;
		
        public class Address {
            @AuraEnabled public String streetAddress;
            @AuraEnabled public String streetAddressAbbreviation;
            @AuraEnabled public String secondaryAddress;
            @AuraEnabled public String city;
            @AuraEnabled public String cityAbbreviation;
            @AuraEnabled public String state;
            @AuraEnabled public String postalCode;
            @AuraEnabled public String province;
            @AuraEnabled public String ZIPCode;
            @AuraEnabled public String ZIPPlus4;
            @AuraEnabled public String urbanization;
            @AuraEnabled public String country;
            @AuraEnabled public String countryISOCode;
        }
		
        public class AdditionalInfo {
            @AuraEnabled public String deliveryPoint;
            @AuraEnabled public String carrierRoute;
            @AuraEnabled public String DPVConfirmation;
            @AuraEnabled public String DPVCMRA;
            @AuraEnabled public String business;
            @AuraEnabled public String centralDeliveryPoint;
            @AuraEnabled public String vacant;
        }
    }