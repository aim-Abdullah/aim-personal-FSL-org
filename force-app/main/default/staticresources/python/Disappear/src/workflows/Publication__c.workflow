<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Change_Record_type_to_Execution</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Execute</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Record type to Execution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UPDT_ISS_FLAG</fullName>
        <description>Automatically select ISS Flag when a value is populated in the ISS # field.</description>
        <field>isISS__c</field>
        <literalValue>1</literalValue>
        <name>UPDT ISS FLAG</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UPDT_MTA_FLAG</fullName>
        <description>Automatically select MTA Flag when a value is populated in the MTA # field.</description>
        <field>is_MTA__c</field>
        <literalValue>1</literalValue>
        <name>UPDT MTA FLAG</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pub_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Execute</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Pub Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_record_type_to_Execution</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Execute</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update record type to Execution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AUTO_SELECT_ISS_FLAG</fullName>
        <actions>
            <name>UPDT_ISS_FLAG</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Publication__c.isISStext__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Automatically select ISS Flag when a value is populated in the ISS # field.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AUTO_SELECT_MTA_FLAG</fullName>
        <actions>
            <name>UPDT_MTA_FLAG</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Publication__c.MTA__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Automatically select MTA Flag when a value is populated in the MTA # field.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
