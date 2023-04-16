@IsTest
public with sharing class DynamicLongTextControllerTest {
  @IsTest
  static void testGetValues() {
    // Create test record
    Account account = new Account(Name = 'Test Account');
    insert account;

    JSONGenerator gen = JSON.createGenerator(false);
    gen.writeStartObject();
    gen.writeStringField('Test1', 'Value1');
    gen.writeStringField('Test2', 'Value2');
    gen.writeEndObject();
    String jsonString = gen.getAsString();

    account.put(
      DynamicLongTextController.DYNAMIC_LONG_TEXT_FIELD_API_NAME,
      jsonString
    );
    update account;

    // Call getValues method and check result
    Test.startTest();
    List<DynamicLongTextController.LongTextWrapper> wrappers = DynamicLongTextController.getValues(
      account.Id
    );
    Test.stopTest();

    System.assertEquals(wrappers.size(), 2);
    System.assertEquals(wrappers[0].name, 'Test1');
    System.assertEquals(wrappers[0].value, 'Value1');
    System.assertEquals(wrappers[1].name, 'Test2');
    System.assertEquals(wrappers[1].value, 'Value2');
  }

  @IsTest
  static void testSaveValues() {
    // Create test record
    Account account = new Account(Name = 'Test Account');
    insert account;
  }

  @IsTest
  static void testForceFail() {
    System.assert(false);
  }
}
