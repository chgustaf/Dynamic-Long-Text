import { LightningElement, wire, api, track } from 'lwc';
import getValues from '@salesforce/apex/DynamicLongTextController.getValues';
import saveValues from '@salesforce/apex/DynamicLongTextController.saveValues';
import { updateRecord } from 'lightning/uiRecordApi';

export default class DynamicLongText extends LightningElement {

    
    @api recordId;
    @track isEditMode = false;
    @track mapData = [];
    focusOn = ""

    @wire(getValues, {recordId : '$recordId'})
    wiredValues({data, error}) {
        if (data) {
            this.mapData = this.toDoubleIterationArray(data);
        } else if (error) {
            console.error('Error while wire service retrieved dynamic long text field data ' , JSON.parse(JSON.stringify(error)));
        } else {
            console.error('Unknown error from wire service while retrieving dynamic long text field data');
        }
    }

    saveMapData(updatedMapData) {
        const flattenedArr = this.arrayToObject(updatedMapData);
        saveValues({recordId: this.recordId, wrapperText: JSON.stringify(flattenedArr)}).then(result => {
            updateRecord({ fields: { Id: this.recordId }})
        }).catch(error => {
            console.error('Error while saving dynamic long text field data ' , JSON.parse(JSON.stringify(error)));
        })
    }
    
    renderedCallback() {
        if (this.focusOn !== "") {
            this.template.querySelector('[data-id="'+this.focusOn+'"]').focus();
            this.focusOn = ""; // Resetting carry variable
        }
    }

    handleChange(event){
        console.log('Handling change');
        this.numberFieldValue = event.target.value;
        console.log('New value  ', this.numberFieldValue);
     }

    handleEdit(event) {
        console.log('EDIT! ' , event.target.dataset.name);
        this.isEditMode = true;

         // Get the ID of the input field to focus on
        const inputFieldId = "stacked-form-element-id-03";
        
        this.focusOn = event.target.dataset.name;
        // Find the input field using querySelector
        //const inputField = this.template.querySelector(`#${inputFieldId}`);
        

        //console.log('inputField ', inputField);
        // Set focus to the input field
        //inputField.focus();
    }

    handleSave() {
        console.log("Bajs handleSave")
        // Make a copy of the current mapData object
        const updatedMapData = JSON.parse(JSON.stringify(this.mapData));
        
        // Iterate over the updatedMapData and update the value for each input field
        updatedMapData.forEach(mapEntry => {
            mapEntry.values.forEach(val => {
                const inputElement = this.template.querySelector(`[data-id="${val.wrapperIdentifier}"]`);
                val.value = inputElement.value;
            });
        });
    
        
        this.saveMapData(updatedMapData);
        // Update the mapData property with the updatedMapData
        this.mapData = updatedMapData;
        
        // Exit the edit mode
        this.isEditMode = false;
    }

    handleCancel() {
        // Discard changes and revert to previous values
        this.isEditMode = false;
    }

    flattenObjectArray(arr) {
        const flattenedArray = [];
        arr.forEach(obj => {
          obj.values.forEach(valueObj => {
            flattenedArray.push({...valueObj, key: obj.key});
          });
        });
        return flattenedArray;
    }

    toDoubleIterationArray(inputArray) {
        const resultArray = [];
        let rowNumber = 1;
        let rowObj = {};
        rowObj["key"] = rowNumber;
        rowObj["values"] = [];

        inputArray.forEach((item, index) => {
            rowObj["values"].push(item);

            if ((index + 1) % 2 === 0) {
                resultArray.push(rowObj);
                rowNumber++;
                rowObj = {};
                rowObj["key"] = rowNumber;
                rowObj["values"] = [];
            }
        });

        if (rowObj["values"].length > 0) {
            resultArray.push(rowObj);
        }
        return resultArray;
    }

    arrayToObject(arr) {
        const obj = {};
        for (const item of arr) {
          for (const value of item.values) {
            obj[value.name] = value.value;
          }
        }
        return obj;
      }
}