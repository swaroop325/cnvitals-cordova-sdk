# Carenow-CarePlixVitals SDK

Although this Cordova plugin is public, you'll need a license for the [CNVitals SDK](http://www.carenowvitals.com/) in order to use it.
If you have a license you'll need to clone this repository and replace the library/framework files with the ones you received from CarePlix Team.

## Installation

To install the plugin to your Cordova project use the Cordova CLI Tool:

```
#!bash
$ cordova plugin add cordova-plugin-cnvitals  
```

To install the plugin to your ionic application use this command:

#!bash
$ ionic cordova plugin add cordova-plugin-cnvitals  

````

## Basic Usage

### Initialization

An instance of the plugin is accessible in JavaScript as `CNVitals`.

#### Full example

```javascript
onDeviceReady: function() {
  // Start measurement, the measurement will stop automatically on the end.
  CNVitals.getVitals(successCallback, failureCallback, params);

  //successCallback
  The function to be executed when the reading has successfully completed
  success(values){
      //where the values are the various measurements obtained 
      [JSON Object String]
  }

  //failureCallback
  The function to be executed when the reading has successfully completed
  failure(value){
      //where the value is the failure reason
      [String]
  }

  //params
  The various key params to be passed to make the sdk work
  {
      api_key : "sample_key",
      scan_token : "sample_token",
      employee_id: 'sample_token',
      language: 'en',
      color_code: '#c82633',
      measured_height: '180',
      measured_weight: '60',
      posture: 'posture'   
  } 
});
````


#### For any Queries

Please visit the [Carenow](https://www.carenow.healthcare).
Contact customer support for obtaining the sdk
(mailto:help@carenow.healhcare)
