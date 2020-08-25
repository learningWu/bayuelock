package cn.i9x.bayue_lock;

import android.content.BroadcastReceiver;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import android.os.SystemClock;
import android.util.Log;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.app.AlertDialog;
import android.app.PendingIntent;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.nfc.NfcAdapter;
import android.nfc.Tag;
import android.os.AsyncTask;
import android.widget.Toast;

import com.st.st25sdk.NFCTag;
import com.st.st25sdk.STException;
import com.st.st25sdk.TagHelper;
import com.st.st25sdk.ndef.NDEFMsg;

import android.content.ContextWrapper;


import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.app.AlertDialog;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.nfc.NfcAdapter;
import android.nfc.Tag;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends FlutterActivity implements TagDiscovery.onTagDiscoveryCompletedListener{
  private NfcAdapter mNfcAdapter;
  private PendingIntent mPendingIntent;
  private static final String NFC_ACTION_CHANNEL = "samples.flutter.io/nfcaction";
  private static final String NFC_UID_CHANNEL = "samples.flutter.io/nfcUID";
  private static final String DEVICE_CHANNEL = "samples.flutter.io/nfcdevice";
  private static final String NFC_DEVICE_INTENT = "com.example.batterylevel.device";
  private static final String NFC_UID_INTENT = "com.example.batterylevel.uid";
  public final static String NFC_TAG_DEVICE_STATUS = "NFC_TAG_DEVICE_STATUS";
  public final static String NFC_TAG_DEVICE_UID = "NFC_TAG_DEVICE_UID";
  public final static String NFC_TAG_DEVICE_PASSWORD_SET_RESULT = "NFC_TAG_DEVICE_PASSWORD_SET_RESULT";
  // Last tag taped
  private NFCTag mNfcTag;
  private String uidString;
  private String  passwordString;

  enum ActionStatus {
    ACTION_SUCCESSFUL,
    ACTION_FAILED,
    TAG_NOT_IN_THE_FIELD
  };

  enum ActionCategorg {
    READ_NFC_TAG_PASSWORD,
    WRITE_NFC_TAG_PASSWORD
  };

  enum NFCDeviceStatus{
    NFC_NOT_AVAILABLE_ON_THIS_PHONE,
    NFC_ENABBLED,
    NFC_DISABLE,
    NFC_TAG_PASSWORD_SET_SUCCEED,
    NFC_TAG_NOT_IN_THE_FIELD,
    NFC_TAG_ACTION_FAILED
  };

  private NFCDeviceStatus nfcDeviceStatus;
  private NFCDeviceStatus NFCTagPasswordResult;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    mNfcAdapter = NfcAdapter.getDefaultAdapter(this);

    GeneratedPluginRegistrant.registerWith(this);
    //注入 method channel
//    MethodChannel channel = new MethodChannel(getFlutterView(), NFC_ACTION_CHANNEL);//获取渠道
//    channel.setMethodCallHandler(this::handleMethod);//设置方法监听
    new MethodChannel(getFlutterView(), NFC_ACTION_CHANNEL).setMethodCallHandler(
            new MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, Result result) {
                if (call.method.equals("getBatteryLevel")) {
                  int batteryLevel = getBatteryLevel();
                  result.success(batteryLevel);
                  if (batteryLevel != -1) {
                    result.success(batteryLevel);
                  } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null);
                  }
                } else if (call.method.equals("getNfcTagUid")) {
                  String batteryLevel = getNfcTagUid();
                  result.success(batteryLevel);
                }else if (call.method.equals("getNfcTagPassword")) {
                  String batteryLevel = getNfcTagPassword();
                  result.success(batteryLevel);
                }else if (call.method.equals("writeNfcTagPassword")) {
                  //Toast.makeText(this, "writeNfcTagPassword", Toast.LENGTH_SHORT).show();
                  SystemClock.sleep(2000);
                  int password = call.argument("password");

                   // int password = 123456;
                  writeNfcTagPassword(password);
                  //result.success("true");
                }else {
                  result.notImplemented();
                }
              }
            }
    );

    EventChannel uidEventChannel = new EventChannel(getFlutterView(),NFC_UID_CHANNEL); //获取通道
    uidEventChannel.setStreamHandler(handleUidChannel()); //上报uid

    EventChannel deviceEventChannel = new EventChannel(getFlutterView(),DEVICE_CHANNEL); //获取通道
    deviceEventChannel.setStreamHandler(handleStateChannel());//上报修改状态


    mPendingIntent = PendingIntent.getActivity(this, 0, new Intent(this, getClass()).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP), 0);

  }


  private StreamHandler handleUidChannel()
  {
    return new StreamHandler() {
      private BroadcastReceiver uidStateChangeReceiver;

      @Override
      public void onListen(Object arguments, EventSink events) {
        Log.e("", "configureFlutterEngine");
        uidStateChangeReceiver = createUidChargingStateChangeReceiver(events);
        registerReceiver(
                uidStateChangeReceiver, new IntentFilter(NFC_UID_INTENT));
      }

      @Override
      public void onCancel(Object arguments) {
        unregisterReceiver(uidStateChangeReceiver);
        uidStateChangeReceiver = null;
      }
    };

  }

  private StreamHandler handleStateChannel()
  {
    return   new StreamHandler() {
      private BroadcastReceiver chargingStateChangeReceiver;

      @Override
      public void onListen(Object arguments, EventSink events) {
        Log.e("", "configureFlutterEngine");

        chargingStateChangeReceiver = createChargingStateChangeReceiver(events);
        registerReceiver(
                chargingStateChangeReceiver, new IntentFilter(NFC_DEVICE_INTENT));
      }

      @Override
      public void onCancel(Object arguments) {
        unregisterReceiver(chargingStateChangeReceiver);
        chargingStateChangeReceiver = null;
      }
    };

  }

  private BroadcastReceiver createUidChargingStateChangeReceiver ( final EventSink events){
    return new BroadcastReceiver() {
      @Override
      public void onReceive(Context context, Intent intent) {
        Log.e("", "createChargingStateChangeReceiver");
        String uid = intent.getStringExtra(NFC_TAG_DEVICE_UID);
        events.success(uid);
      }
    };
  }

  private BroadcastReceiver createChargingStateChangeReceiver ( final EventSink events){
    return new BroadcastReceiver() {
      @Override
      public void onReceive(Context context, Intent intent) {
        Log.e("", "createChargingStateChangeReceiver");

        int data1 = intent.getIntExtra(NFC_TAG_DEVICE_STATUS, -1);
        int data2 = intent.getIntExtra(NFC_TAG_DEVICE_PASSWORD_SET_RESULT, -1);
        if(data1 != -1){
          events.success(data1);
        }
        if(data2 != -1)
        {
          events.success(data2);
        }
      }
    };
  }


  private void handleMethod(MethodCall methodCall, MethodChannel.Result result)
  {

//   return new MethodCallHandler() {
//      @Override
//      public void onMethodCall(MethodCall call, Result result) {
//        if (call.method.equals("getBatteryLevel")) {
//          int batteryLevel = sgetBatteryLevel();
//          result.success(batteryLevel);
//          if (batteryLevel != -1) {
//            result.success(batteryLevel);
//          } else {
//            result.error("UNAVAILABLE", "Battery level not available.", null);
//          }
//        } else if (call.method.equals("getNfcTagUid")) {
//          String batteryLevel = getNfcTagUid();
//          result.success(batteryLevel);
//        }else if (call.method.equals("getNfcTagPassword")) {
//          String batteryLevel = getNfcTagPassword();
//          result.success(batteryLevel);
//        }else if (call.method.equals("writeNfcTagPassword")) {
//          int password = call.argument("password");
//
//          writeNfcTagPassword(password);
//          result.success("true");
//        }else {
//          result.notImplemented();
//        }
//      }
//    };
    switch (methodCall.method)
    {
      case "getNfcTagUid":
        String uid = getNfcTagUid();
        result.success(uid);
        break;
      case "getNfcTagPassword":
        result.success(getNfcTagPassword());
        break;
      case "writeNfcTagPassword":
        writeNfcTagPassword(methodCall.argument("password"));
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private int getBatteryLevel () {
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
      return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
    } else {
      Intent intent = new ContextWrapper(getApplicationContext()).
              registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
      return (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
              intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
    }
  }

  private String getNfcTagUid () {
    return  uidString;
  }

  private String getNfcTagPassword () {
    if (mNfcTag != null) {
      // All the actions doing a transceive() to communicate with the tag should be done
      // in an Async Task to avoid disturbance of Android UI Thread
      new asyncTaskWriteUriNdefMessage().execute(ActionCategorg.READ_NFC_TAG_PASSWORD);
    }
    return passwordString;
  }

  private void writeNfcTagPassword(int  buff){
    mMessageData[0] = (byte)(buff >>> 24);
    mMessageData[1] = (byte)(buff >>>16);
    mMessageData[2] = (byte)(buff >>> 8);
    mMessageData[3] = (byte)buff;
    if (mNfcTag != null) {
      // All the actions doing a transceive() to communicate with the tag should be done
      // in an Async Task to avoid disturbance of Android UI Thread
      new asyncTaskWriteUriNdefMessage().execute(ActionCategorg.WRITE_NFC_TAG_PASSWORD);
    }
  }


  @Override
  protected void onPause() {
    super.onPause();

    if (mNfcAdapter != null) {
      mNfcAdapter.disableForegroundDispatch(this);
    }
  }

  @Override
  protected void onResume() {
    Intent intent = getIntent();
    Log.d("onResume", "Resume mainActivity intent: " + intent);

    super.onResume();
    Intent NfcDeviceIntert = new Intent(NFC_DEVICE_INTENT);

    // Check if if this phone has NFC hardware
    if (mNfcAdapter == null) {
      nfcDeviceStatus = NFCDeviceStatus.NFC_NOT_AVAILABLE_ON_THIS_PHONE;
      NfcDeviceIntert.putExtra(NFC_TAG_DEVICE_STATUS, nfcDeviceStatus.ordinal());
      sendBroadcast(NfcDeviceIntert);

      AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);

      // set title
      alertDialogBuilder.setTitle("Warning!");

      // set dialog message
      alertDialogBuilder
              .setMessage("This phone doesn't have NFC hardware!")
              .setCancelable(true)
              .setPositiveButton("Leave", new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialog,int id) {
                  dialog.cancel();
                  finish();
                }
              });

      // create alert dialog
      AlertDialog alertDialog = alertDialogBuilder.create();

      // show it
      alertDialog.show();

    } else {
      //Toast.makeText(this, "We are ready to play with NFC!", Toast.LENGTH_SHORT).show();

      // Give priority to the current activity when receiving NFC events (over other actvities)
      IntentFilter[] nfcFilters = null;
      String[][] nfcTechLists = null;
      mNfcAdapter.enableForegroundDispatch(this, mPendingIntent, nfcFilters, nfcTechLists);
      Log.d("onResume", "enableForegroundDispatch " + intent);

      if (mNfcAdapter.isEnabled()) {
        // NFC enabled
        nfcDeviceStatus = NFCDeviceStatus.NFC_ENABBLED;
        NfcDeviceIntert.putExtra(NFC_TAG_DEVICE_STATUS, nfcDeviceStatus.ordinal());

        sendBroadcast(NfcDeviceIntert);

      } else {
        nfcDeviceStatus = NFCDeviceStatus.NFC_DISABLE;

        NfcDeviceIntert.putExtra(NFC_TAG_DEVICE_STATUS, nfcDeviceStatus.ordinal());
        sendBroadcast(NfcDeviceIntert);
        // NFC disabled
      }

    }

    // The current activity can be resumed for several reasons (NFC tag tapped is one of them).
    // Check what was the reason which triggered the resume of current application
    String action = intent.getAction();

    if (action.equals(NfcAdapter.ACTION_NDEF_DISCOVERED) ||
            action.equals(NfcAdapter.ACTION_TECH_DISCOVERED) ||
            action.equals(NfcAdapter.ACTION_TAG_DISCOVERED)) {

      // If the resume was triggered by an NFC event, it will contain an EXTRA_TAG providing
      // the handle of the NFC Tag
      Tag androidTag = intent.getParcelableExtra(NfcAdapter.EXTRA_TAG);
      if (androidTag != null) {
        Toast.makeText(this, "Starting Tag discovery", Toast.LENGTH_SHORT).show();

        // This action will be done in an Asynchronous task.
        // onTagDiscoveryCompleted() of current activity will be called when the discovery is completed.
        new TagDiscovery(this).execute(androidTag);
      }
    }

  }

  @Override
  protected void onNewIntent(Intent intent) {
    super.onNewIntent(intent);

    // onResume() gets called after this to handle the intent
    setIntent(intent);
  }

  @Override
  public void onTagDiscoveryCompleted(NFCTag nfcTag, TagHelper.ProductID productId, STException error) {

    if (error != null) {
      Toast.makeText(getApplication(), "Error while reading the tag: " + error.toString(), Toast.LENGTH_LONG).show();
      return;
    }
    Intent NfcUIDIntert = new Intent(NFC_UID_INTENT);

    if (nfcTag != null) {
      mNfcTag = nfcTag;
//            if (mNfcTag != null) {
//                // All the actions doing a transceive() to communicate with the tag should be done
//                // in an Async Task to avoid disturbance of Android UI Thread
//                new asyncTaskWriteUriNdefMessage().execute(ActionCategorg.READ_NFC_TAG_PASSWORD);
//            }
      try {
        String tagName = nfcTag.getName();

        uidString = nfcTag.getUidString();

        NfcUIDIntert.putExtra(NFC_TAG_DEVICE_UID,uidString);

        sendBroadcast(NfcUIDIntert);

      } catch (STException e) {
        e.printStackTrace();
        Toast.makeText(this, "Discovery successful but failed to read the tag!", Toast.LENGTH_LONG).show();
      }

    } else {
      Toast.makeText(this, "Tag discovery failed!", Toast.LENGTH_LONG).show();
    }
  }
  private byte[] mMessageData = new byte[4];

  /**
   * Async Task writing a NDEF message into the tag
   */
  private class asyncTaskWriteUriNdefMessage extends AsyncTask<ActionCategorg, Void, ActionStatus> {


    public asyncTaskWriteUriNdefMessage() {

    }
    /**
     * @param byte[]
     * @return int
     */
    public int byteArrayToInt(byte[] b) {
      byte[] a = new byte[4];
      int i = a.length - 1, j = b.length - 1;
      for (; i >= 0; i--, j--) {//从b的尾部(即int值的低位)开始copy数据
        if (j >= 0)
          a[i] = b[j];
        else
          a[i] = 0;//如果b.length不足4,则将高位补0
      }
      int v0 = (a[0] & 0xff) << 24;
      int v1 = (a[1] & 0xff) << 16;
      int v2 = (a[2] & 0xff) << 8;
      int v3 = (a[3] & 0xff) ;
      return v0 + v1 + v2 + v3;
    }
    @Override
    protected ActionStatus doInBackground(ActionCategorg... param) {
      ActionStatus result;
      Intent NfcUIDIntert = new Intent(NFC_DEVICE_INTENT);

      try {

        if(param[0] == ActionCategorg.READ_NFC_TAG_PASSWORD)
        {
          byte[] password = new byte[4];
          password = mNfcTag.readBytes(16, 4);

          int data = byteArrayToInt(password);

          passwordString = Integer.toString(data);

        }
        else if(param[0] == ActionCategorg.WRITE_NFC_TAG_PASSWORD )
        {
          mNfcTag.writeBytes(16, mMessageData);
//          Toast.makeText(MainActivity.this, "Write Bytes"+mMessageData, Toast.LENGTH_LONG).show();
          for(int i=0; i < 20;i++)
          {
            byte[] password = new byte[4];
            password = mNfcTag.readBytes(16, 4);

            int data = byteArrayToInt(password);

            if( data == 0x00000000)
            {
              NFCTagPasswordResult = NFCDeviceStatus.NFC_TAG_PASSWORD_SET_SUCCEED;
              NfcUIDIntert.putExtra(NFC_TAG_DEVICE_PASSWORD_SET_RESULT,NFCTagPasswordResult.ordinal());

              sendBroadcast(NfcUIDIntert);
              break;
            }
            SystemClock.sleep(500);
            Log.e("", "read nfc tag password");
          }
        }
        else
        {
          /* do nothing */
        }

        result = ActionStatus.ACTION_SUCCESSFUL;

      } catch (STException e) {
        switch (e.getError()) {
          case TAG_NOT_IN_THE_FIELD:
            result = ActionStatus.TAG_NOT_IN_THE_FIELD;
            NFCTagPasswordResult = NFCDeviceStatus.NFC_TAG_NOT_IN_THE_FIELD;
            NfcUIDIntert.putExtra(NFC_TAG_DEVICE_PASSWORD_SET_RESULT,NFCTagPasswordResult);

            sendBroadcast(NfcUIDIntert);

            break;

          default:
            e.printStackTrace();
            NFCTagPasswordResult = NFCDeviceStatus.NFC_TAG_ACTION_FAILED;
            NfcUIDIntert.putExtra(NFC_TAG_DEVICE_PASSWORD_SET_RESULT,NFCTagPasswordResult);

            result = ActionStatus.ACTION_FAILED;
            break;
        }
      }

      return result;
    }

    @Override
    protected void onPostExecute(ActionStatus actionStatus) {

      switch(actionStatus) {
        case ACTION_SUCCESSFUL:
          Toast.makeText(MainActivity.this, "Write successful", Toast.LENGTH_LONG).show();
          break;

        case ACTION_FAILED:
          Toast.makeText(MainActivity.this, "Write failed!", Toast.LENGTH_LONG).show();
          break;

        case TAG_NOT_IN_THE_FIELD:
          Toast.makeText(MainActivity.this, "Tag not in the field!", Toast.LENGTH_LONG).show();
          break;
      }

      return;
    }
  }
}
