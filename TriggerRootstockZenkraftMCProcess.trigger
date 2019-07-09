trigger TriggerRootstockZenKraftMCProcess on zkmulti__MCBulk_Shipment_Status__c (after insert, after update) {
    String VALIDATED = 'VALIDATED';
    String SUCCESS = 'SUCCESS';
    String VALIDATION_COMPLETED = 'VALIDATION_COMPLETED';
    String PROCESSING_COMPLETED = 'PROCESSING_COMPLETED';
    String rstkPkgPrefixWithUnderscores = 'rstk__'; // PACKAGED ORG NOTE:  change to rstk__ 
    for (zkmulti__MCBulk_Shipment_Status__c bsStatus : Trigger.new) {
        System.debug('[TriggerRootstockZenKraftMCProcess] handling insert of Bulk Shipment Status: ' + bsStatus);
// check for READY_FOR_SHIPMENT = do shipment
        if (Trigger.isInsert && String.isBlank(bsStatus.zkmulti__BatchId__c) && bsStatus.zkmulti__Status_Message__c == 'READY_FOR_SHIPMENT') {
            String bsID = zkmulti.BulkShipmentInterface.asynchronousProcessBulkShipment(bsStatus.zkmulti__Bulk_Shipment__c);
            System.debug('[TriggerRootstockZenKraftMCProcess] handling shipping: ' + bsStatus);
            continue;
        }
        String statusStr = bsStatus.zkmulti__Status__c;
        String batchId = bsStatus.zkmulti__BatchId__c;
        Boolean isSuccess = false;
        Boolean qShipStatiiExist = false;
        Boolean needToSendEmail = true; // Only case of successful validation and successful call to interface process method warrants no email being sent.
        String eSubject = 'Rootstock ZenKraftMC ' + statusStr + ' Notification';
        String eMessage = 'Rootstock - ZenKraftMC message: ';
        zkmulti__Shipment_Status__c[] qShipStatii = [select id, zkmulti__Batch_Id__c, zkmulti__Bulk_Shipment__c, zkmulti__Shipment__c, zkmulti__Status__c, zkmulti__Status_Message__c 
                                                     from zkmulti__Shipment_Status__c
                                                     where zkmulti__Batch_Id__c = :batchId];
        Set<zkmulti__Shipment_Status__c> errorSet = new Set<zkmulti__Shipment_Status__c>();
        if (qShipStatii == null || qShipStatii.size() == 0) {
            if (statusStr != PROCESSING_COMPLETED){
                eMessage = 'MC Bulk Shipment Status: ' +statusStr +' for Bulk Shipment: ' +batchId;
            }
            else continue;
        } else {
            qShipStatiiExist = true;
            for (zkmulti__Shipment_Status__c qShipStatus : qShipStatii){
                String qStatus = qShipStatus.zkmulti__Status__c;
                Boolean isBadStatus = !qStatus.equalsIgnoreCase(SUCCESS) && !qStatus.equalsIgnoreCase(VALIDATED);
                Boolean isShipmentCreationIssue = qStatus.equalsIgnoreCase(SUCCESS) && qShipStatus.zkmulti__Shipment__c == null;
                if ( isBadStatus || isShipmentCreationIssue ){
                    errorSet.add(qShipStatus);
                }
            }
            isSuccess = errorSet.isEmpty();
        }
        
        if (qShipStatiiExist && statusStr.equalsIgnoreCase(VALIDATION_COMPLETED)) {
            if (!isSuccess) {
                for (zkmulti__Shipment_Status__c qShipStatus : qShipStatii){
                    eMessage = eMessage + 'MC Shipment => id: ' + qShipStatus.zkmulti__Shipment__c + ', status: ' + qShipStatus.zkmulti__Status__c + ', message: ' + qShipStatus.zkmulti__Status_Message__c;
                }
            }
        } else if (qShipStatiiExist && statusStr.equalsIgnoreCase(PROCESSING_COMPLETED)){
            if (isSuccess){
                try {
                    eMessage += 'ZenKraftMC shipment(s) were successfully created.';
                    for (zkmulti__Shipment_Status__c qShipStatus : qShipStatii){
                        String soshipQry = 'select id, name from ' + rstkPkgPrefixWithUnderscores + 'soship__c where ' + rstkPkgPrefixWithUnderscores + 'soship_zenkraft_queued_shipment_id__c = \'' + qShipStatus.zkmulti__Shipment__c + '\' limit 1';
                        
                        sObject[] shipperResults = Database.query(soshipQry);
                        if (shipperResults != null && shipperResults.size() > 0){
                            sObject shipper = shipperResults[0];
// PACKAGED ORG NOTE: Add rstk. prefix to ZenKraft class 
// rstk.Zenkraft.triggerUpdateMCShipment
// Update the shipment and container info  
// RCB: 24082
                            rstk.Zenkraft.triggerUpdateMCShipment(qShipStatus.zkmulti__Shipment__c);
                        }
                        eMessage += 'MC Shipment: ' + qShipStatus.zkmulti__Shipment__c;
                    }
                } catch (Exception ex){
                    eMessage += 'MC Exception was thrown: message: ' + ex.getMessage() + ' stacktrace: ' + ex.getStackTraceString() + ' type name: ' + ex.getTypeName() + ' line number: ' + ex.getLineNumber();
                }
            } else {
                eMessage = eMessage + 'Error(s) were found after ZenKraftMC process attempt.';
                for (zkmulti__Shipment_Status__c qShipStatus : qShipStatii){
                    eMessage = eMessage + 'Shipment => id: ' + qShipStatus.Id + ', status: ' + qShipStatus.zkmulti__Status__c + ', message: ' + qShipStatus.zkmulti__Status_Message__c;
                }
            }
        }
        if (needToSendEmail){
            zkmulti__MCBulk_Shipment__c bs = [select id, CreatedBy.email from zkmulti__MCBulk_Shipment__c where id = :bsStatus.zkmulti__Bulk_Shipment__c limit 1];
            String sendTo = bs.CreatedBy.email;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] { sendTo };
            mail.setToAddresses(toAddresses);
            mail.setReplyTo(sendTo);
            mail.setSubject(eSubject);
            mail.setHtmlBody(eMessage);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }, false);
        }
    }
}
