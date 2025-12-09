@IsTest
public with sharing class KeyValueSettingsModelTest {
	@isTest
	public static  void KeyValueSettingsModelTest() {
		KeyValueSettingsModel.ClearKey(null);
		KeyValueSettingsModel.ClearKey('test');
		KeyValueSettingsModel.ClearKey('');
		
		KeyValueSettings__c result = KeyValueSettingsModel.SetKey('testKey', 'testValue');
		System.AssertEquals(result.key__c, 'testKey');
		System.AssertEquals(result.value__c, 'testValue');
		
		KeyValueSettings__c getResult = KeyValueSettingsModel.GetKey('testKey');
		System.AssertEquals(getResult.key__c, 'testKey');
		System.AssertEquals(getResult.value__c, 'testValue');
		
		KeyValueSettings__c result2 = KeyValueSettingsModel.SetKey('testKey2', 'testValue2');
		System.AssertEquals(result2.key__c, 'testKey2');
		System.AssertEquals(result2.value__c, 'testValue2');
		
		KeyValueSettings__c getResult3 = KeyValueSettingsModel.GetKey('testKey');
		System.AssertEquals(getResult3.key__c, 'testKey');
		System.AssertEquals(getResult3.value__c, 'testValue');
		
		
		KeyValueSettings__c result4 = KeyValueSettingsModel.SetKey('testKey4', 'testValue4');
		System.AssertEquals(KeyValueSettingsModel.getValue('testKey4'),'testValue4');

		KeyValueSettingsModel.ClearKey('testKey5');
		System.AssertEquals(KeyValueSettingsModel.getValue('testKey5'),null);
		System.AssertNotEquals(null, KeyValueSettingsModel.getKey('testKey5','defaultValue'));
		
		KeyValueSettings__c result5 = KeyValueSettingsModel.SetKey('testKey5', 'value5');
		System.AssertEquals(KeyValueSettingsModel.GetKey('testKey5','defaultValue').value__c,'value5');
		
		KeyValueSettingsModel.ClearKey('testKey');
		KeyValueSettingsModel.ClearKey('testKey2');
		

	}
}