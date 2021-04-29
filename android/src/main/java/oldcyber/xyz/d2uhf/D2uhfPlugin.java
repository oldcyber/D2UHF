package oldcyber.xyz.d2uhf;

import androidx.annotation.NonNull;

import com.senter.iot.support.openapi.uhf.UhfD2;
import com.senter.iot.support.openapi.uhf.UhfD2.AccessPassword;
import com.senter.iot.support.openapi.uhf.UhfD2.Bank;
import com.senter.iot.support.openapi.uhf.UhfD2.UII;
import com.senter.iot.support.openapi.uhf.UhfD2.UmdErrorCode;
import com.senter.iot.support.openapi.uhf.UhfD2.UmdFrequencyPoint;
import com.senter.iot.support.openapi.uhf.UhfD2.UmdOnIso18k6cRead;

import java.util.concurrent.TimeUnit;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import static oldcyber.xyz.d2uhf.DataTransfer.getBytesByHexString;
import static oldcyber.xyz.d2uhf.DataTransfer.xGetString;


/**
 * D2uhfPlugin
 */
public class D2uhfPlugin implements FlutterPlugin, MethodCallHandler {

    public static String curData = "0";
    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "d2uhf");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {
        handleMethods(call, result);
    }

    private void handleMethods(@NonNull MethodCall call, @NonNull final Result result) {
        switch (call.method) {
            case "onInit":
                result.success(UhfD2.getInstance().init());
                break;
//       case "onUnInit":
//         result.success(UhfD2.getInstance().uninit());
//         break;
            case "getPower":
                result.success(UhfD2.getInstance().getOutputPower());
                break;
            case "setPower":
                final int newPower = call.argument("newPower");
                result.success(UhfD2.getInstance().setOutputPower(newPower));
                break;
            case "getTemperature":
                result.success(UhfD2.getInstance().getReadersTemperature());
                break;
            case "getFrequencyRegion":
                final UhfD2.UmdFrequencyRegionInfo regionInfo = UhfD2.getInstance().getFrequencyRegion();
                if (regionInfo != null) {
                    final UhfD2.UmdFrequencyRegion region;
                    result.success(region = regionInfo.getRegion());
                }
                break;
            case "getTag":
                boolean isSuccess;
                int ptr = 0;
                int cnt = 1;
                final Bank bank = Bank.ValueOf(1);

                UhfD2.getInstance().iso18k6cRead(getAccessPassword(), bank, ptr, cnt,
                        new UmdOnIso18k6cRead() {
                            @Override
                            public void onFailed(UmdErrorCode error) {
                                curData = "0";
                                System.out.println("error:" + error.name());

                            }

                            @Override
                            public void onTagRead(
                                    int tagCount,
                                    UII uii,
                                    byte[] data,
                                    UmdFrequencyPoint frequencyPoint,
                                    Integer antennaId,
                                    int readCount
                            ) {
                                curData = xGetString(uii.getBytes());
                            }
                        }
                );

/// --- Wait for tag reading ---
                try {
                    TimeUnit.SECONDS.sleep(1);
                } catch (InterruptedException ie) {
                }
                if (curData == "0") {
                    result.success("Метка не обнаружена!");
                } else {
                    System.out.println(curData);
                    result.success(curData);
                }
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    /// Default password for any tag
    private static AccessPassword getAccessPassword() {
        String pwd = "00000000";
        pwd = pwd.replaceAll(" ", "");

        if (pwd.length() == 8) {
            byte[] bs = getBytesByHexString(pwd);
            if (bs == null || bs.length != 4) {
                return null;
            }
            return AccessPassword.getNewInstance(bs);
        }
        return null;
    }
}


//TODO:
// Wait for data instead of pause for 1 second

//  Object foo = new Object();
//synchronized(foo) {
//        byte[] bs = uii.getBytes();
//        if (bs != null) {
//        StringBuilder sBuffer = new StringBuilder();
//        for (int i = 0; i < bs.length; i++) {
//        sBuffer.append(String.format("%02x ", bs[i]));
//        }
//        curData = sBuffer.toString();
//        foo.notify();
//        }
//        }
//
//        try {
//synchronized(foo) {
//        while(curData == "0") {
//        foo.wait();
//        }
//        sendResult(curData);
//        }
//        } catch (InterruptedException e) {//handleInterruption();
//        }


