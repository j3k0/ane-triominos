package com.triominos.ane.AneTriominos;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

import java.util.HashMap;
import java.util.Map;

public class ExtensionContext extends FREContext {

  public ExtensionContext() {
  }
	
	@Override
	public void dispose() {
		Extension.context = null;
	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		return functionMap;
	}
}
