package com.triominos.ane.AneTriominos;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class Extension implements FREExtension {

	public static String TAG = "AneTriominos";
	public static ExtensionContext context;

	public FREContext createContext(String extId)
	{
		context = new ExtensionContext();
		return context;
	}

	public void dispose()
	{
		context = null;
	}
	
	public void initialize() {

	}
	
	public static void logToAIR(String message)
	{
		Log.d(TAG, message);
		
		if (context != null)
		{
			try {
				context.dispatchStatusEventAsync("LOGGING", message);
			} catch (IllegalStateException e) {
				Log.e(TAG, "logToAIR: couldn't dispatch AS3 logging event", e);
			}
		}
	}
}
