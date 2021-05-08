package com.carenow.cnvitalssdk;
import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;

import androidx.core.app.ActivityCompat;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import sdk.carenow.cnvitals.Calibration;

import static android.app.Activity.RESULT_OK;

/**
 * This class echoes a string called from JavaScript.
 */
public class CNVitals extends CordovaPlugin {
    private CallbackContext callbackContext;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("getVitals")) {
            Context context = cordova.getActivity().getApplicationContext();
            this.callbackContext = callbackContext;
            PluginResult r = new PluginResult(PluginResult.Status.NO_RESULT);
            r.setKeepCallback(true);
            callbackContext.sendPluginResult(r);

            Intent i = new Intent(context, Calibration.class);
            i.putExtra("api_key", args.getJSONObject(0).getString("api_key"));
            i.putExtra("scan_token", args.getJSONObject(0).getString("scan_token"));
            i.putExtra("user_id", args.getJSONObject(0).getString("user_id"));
            cordova.setActivityResultCallback (this);
            cordova.startActivityForResult(this, i, 90);
            return true;
        }
        return false;
    }

    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);
        if (resultCode == RESULT_OK) {
            StringBuilder str = new StringBuilder();
            JSONObject item = new JSONObject();
            Context context = cordova.getActivity().getApplicationContext();
            SharedPreferences pref = context.getSharedPreferences("CNV", 0);
            int heartrate = pref.getInt("heart_rate", 0);
            int O2R = pref.getInt("spo2", 0);
            int Breath = pref.getInt("resp_rate", 0);
            int BPM = pref.getInt("heart_rate_cnv", 0);
            String ppgData = pref.getString("ecgdata", "");
            String ecgData = pref.getString("ppgdata", "");
            String heartData = pref.getString("heartdata", "");
            try {
                item.put("breath", Breath);
                item.put("O2R", O2R);
                item.put("bpm2", BPM);
                item.put("bpm", heartrate);
                item.put("ecgdata", ecgData);
                item.put("ppgdata", ppgData);
                item.put("heartdata", heartData);
            } catch (JSONException e) {

            }
            this.callbackContext.success(item.toString());
        }else if (resultCode == 2){
            this.callbackContext.error("User Cancelled");
        }else {
            if (resultCode != 0){
                Context context = cordova.getActivity().getApplicationContext();
                SharedPreferences pref = context.getSharedPreferences("CNV", 0);
                String message = pref.getString("message", "");
                this.callbackContext.error(message);
            }
        }
    }

    //required to make callbacks work with the plugin
    public void onRestoreStateForActivityResult(Bundle state, CallbackContext callbackContext) {
        this.callbackContext = callbackContext;
    }

}