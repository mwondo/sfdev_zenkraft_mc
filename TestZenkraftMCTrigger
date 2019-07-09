@isTest
private class TestZenkraftMCTrigger {

    private static testMethod void test1() {
        Test.startTest();
        
        zkmulti__MCShipmate_Preference__c shipmatePref = new  zkmulti__MCShipmate_Preference__c(
            zkmulti__Carrier__c = 'FedEx');
        insert shipmatePref;
        
        zkmulti__MCBulk_Shipment__c bulkShipment = new zkmulti__MCBulk_Shipment__c(
            zkmulti__Shipmate_Preference__c = shipmatePref.Id);
        insert bulkShipment;

        zkmulti__MCShipment__c ship = new zkmulti__MCShipment__c(
            zkmulti__Bulk_Shipment__c = bulkShipment.Id,
            zkmulti__Carrier__c = 'FedEx',
            zkmulti__DropoffType__c = 'DROP_BOX',
            zkmulti__Label_Image_Type__c = 'PNG',
            zkmulti__Sender_Name__c = 'name', //shipmatePref.zkmulti__Sender_Name_Default__c,   
            zkmulti__Sender_City__c = 'name', //shipmatePref.zkmulti__Shipping_City__c,
            zkmulti__Sender_Company__c = 'name', //shipmatePref.zkmulti__Company_Name__c,
            zkmulti__Sender_Country__c = 'name', //shipmatePref.zkmulti__Shipping_Country__c,
            zkmulti__Sender_Email__c = 'x@y.com', //shipmatePref.zkmulti__Sender_Email_Default__c,
            zkmulti__Sender_Phone__c = 'name', //shipmatePref.zkmulti__Sender_Phone_Default__c,
            zkmulti__Sender_State_Province__c = 'name', //shipmatePref.zkmulti__Shipping_State__c,
            zkmulti__Sender_Street__c = 'name', //shipmatePref.zkmulti__Shipping_Street__c,
            zkmulti__Sender_Zip_Postal_Code__c = 'name', //shipmatePref.zkmulti__Shipping_Zip_Postal_Code__c,
            zkmulti__Sender_Address_is_Residential__c = false,
            zkmulti__Recipient_City__c = 'city', //con.MailingCity,
            zkmulti__Recipient_Company__c = 'city', //con.Account.Name,
            zkmulti__Recipient_Country__c = 'city', //con.MailingCountry,
            zkmulti__Recipient_Email__c = 'x@y.com', //con.Email,
            zkmulti__Recipient_Name__c = 'city', //con.FirstName + ' ' + con.LastName,
            zkmulti__Recipient_Phone__c = 'city', //con.Phone,
            zkmulti__Recipient_State_Province__c = 'city', //con.MailingState,
            zkmulti__Recipient_Street__c = 'city', //con.MailingStreet,
            zkmulti__Recipient_Zip_Postal_Code__c = 'city', //con.MailingPostalCode,
            zkmulti__Ship_Date__c = Date.today(),
            zkmulti__Currency__c = 'USD',
            zkmulti__Dimension_Units__c = 'IN',
            zkmulti__Weight_Units__c = 'LB',
            zkmulti__Service_Type__c = 'FEDEX_2_DAY_AM',
            zkmulti__Package_Type__c = 'YOUR_PACKAGING',
            zkmulti__Payment_Type__c = 'SENDER',
            zkmulti__Billing_Account_Number__c = 'city', //shipmatePref.zkmulti__AccountNumber__c,
            zkmulti__Billing_Country__c = 'city'); //shipmatePref.zkmulti__Billing_Country__c);
        insert ship;

        zkmulti__MCPackage__c pkg = new zkmulti__MCPackage__c (
            zkmulti__Shipment__c = ship.Id,
            zkmulti__Weight__c = 1,
            zkmulti__Length__c = 1,
            zkmulti__Width__c = 1,
            zkmulti__Height__c = 1,
            zkmulti__DeclaredValue__c = 0);
        insert pkg;
        
        zkmulti__MCBulk_Shipment_Status__c bulkShipmentStatus = new zkmulti__MCBulk_Shipment_Status__c(
            zkmulti__Bulk_Shipment__c = bulkShipment.Id,
            zkmulti__Status__c = 'COMPLETED',
            zkmulti__Status_Message__c = 'SHIPMENT');
        insert bulkShipmentStatus;
        
        zkmulti__MCBulk_Shipment_Status__c bulkShipmentStatus1 = new zkmulti__MCBulk_Shipment_Status__c(
            zkmulti__Bulk_Shipment__c = bulkShipment.Id,
            zkmulti__Status__c = 'PROCESSING_COMPLETED',
            zkmulti__Status_Message__c = 'READY');
        insert bulkShipmentStatus1;
        
        zkmulti__MCBulk_Shipment_Status__c bulkShipmentStatus2 = new zkmulti__MCBulk_Shipment_Status__c(
            zkmulti__Bulk_Shipment__c = bulkShipment.Id,
            zkmulti__Status__c = 'PROCESSING_COMPLETED',
            zkmulti__Status_Message__c = 'READY_FOR_SHIPMENT');
        insert bulkShipmentStatus2;
        
        
        Test.stopTest();
    }
}
