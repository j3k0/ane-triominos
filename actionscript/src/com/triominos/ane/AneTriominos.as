package com.triominos.ane.AneTriominos {

	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

    /**
     *
     */
    public class AneTriominos extends EventDispatcher {

        private static const EXTENSION_ID:String = "com.triominos.ane.AneTriominos";
        private static var _instance:AneTriominos = null;

        /**
         * "private" singleton constructor
         */
        public function AneTriominos() {
            super();
            if (_instance)
                throw Error("This is a singleton, use '.instance', do not call the constructor directly.");
            _instance = this;
        }

        private var __context:ExtensionContext;
        private function getContext():ExtensionContext
        {
            if (!__context) {
                __context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
                if (!__context) {
                    _log("ERROR", "Extension context is null. Please check if extension.xml is setup correctly.");
                } else {
                    __context.addEventListener(StatusEvent.STATUS, _onStatus);
                }
            }
            return __context;
        }

        private function callContext(...args):*
        {
            var context: ExtensionContext = getContext();
            if(!context) {
                _log("ERROR", "Extension context is null. Please check if extension.xml is setup correctly.")
                return null;
            }
            try {
                return context.call.apply(context, args);
            } catch (e: Error) {
                _log("ERROR", "Error calling extension context: " + e.message + " : " + e.getStackTrace());
            }
            return null;
        }

        /**
         *
         * @param e
         */
        private function _onStatus(e:StatusEvent):void {
        }
	}
}
