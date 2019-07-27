package com.upcwangying.plugin.asr;

import android.util.Log;

import io.flutter.plugin.common.MethodChannel;

public class ResultStateful implements MethodChannel.Result {
    private static final String TAG = "ResultStateful";
    private boolean called = false;
    private MethodChannel.Result result;

    public static ResultStateful of(MethodChannel.Result result) {
        return new ResultStateful(result);
    }

    private ResultStateful(MethodChannel.Result result) {
        this.result = result;
    }

    @Override
    public void success(Object o) {
        if (called) {
            printError();
            return;
        }
        called = true;
        result.success(o);
    }

    @Override
    public void error(String s, String s1, Object o) {
        if (called) {
            printError();
            return;
        }
        called = true;
        result.error(s, s1, o);
    }

    @Override
    public void notImplemented() {
        if (called) {
            printError();
            return;
        }
        called = true;
        result.notImplemented();
    }

    private void printError() {
        Log.e(TAG, "error: result called.");
    }
}
