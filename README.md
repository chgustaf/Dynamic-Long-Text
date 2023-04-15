# Dynamic Long Text Fields

<a href="https://githubsfdeploy.herokuapp.com?owner=chgustaf&amp;repo=dynamic-long-text">
<img src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png" alt="Deploy to Salesforce" />
</a>

## Rationale
Creating and specifying new fields can be a time-consuming process in fast-paced projects, potentially leading to inefficiencies and data quality issues. Users may struggle to keep up with changing business needs, resulting in further difficulties.

This solution provides a way to add extra data to cases, accounts, contacts, and other entities in Salesforce without creating and specifying new fields. The process is streamlined, reducing overheads and improving efficiency.

It allows you to send fields and field data in JSON format, which is stored in text fields and seamlessly presented to Salesforce users on the record page. Users can modify the field values just like ordinary fields.

## Installation
The default package includes the addition of Dynamic Long Text Fields to the Account object. To complete the setup process, please follow these steps:

1. Deploy the metadata to your organization.
2. Configure field-level security settings to make the DynamicLongTextField__c field visible for users.
3. Place the "dynamicLongText" component on a record page for the Account, preferably immediately below the detail page.
4. Assign the example JSON (provided in the section below) to the DynamicLongTextField.
5. Finally, open the record page of the account to confirm that the setup has been completed successfully.

If you wish to add Dynamic Long Text Fields to other objects, follow these steps:

1. Deploy the metadata to your organization.
2. Add a Long Text field to the desired object.
3. Create a new record in the Dynamic Field Mapping custom metadata, setting the name to the API name of the object that the Long Text field was added to and the "Field API Name" to the API name of the Long Text Field.
4. Place the "dynamicLongText" component on a record page for the object in question.
5. Assign the example JSON (provided in the section below) to the DynamicLongTextField.
6. Finally, open the record page of the account to confirm that the setup has been completed successfully.

## Example JSON
{"Field1":"Test","Field2":"Test Field24","Field3":"More textsdafasdf1234","Field4":"More text"}