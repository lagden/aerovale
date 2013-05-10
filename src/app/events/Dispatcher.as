package app.events
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class Dispatcher extends EventDispatcher
	{
		public const ON_UPLOAD:String = "onUpload";
		public const ON_UPLOAD_COMPLETE:String = "onUploadComplete";
		public const ON_LOADING_SHOW:String = "onLoadingShow";
		public const ON_LOADING_HIDE:String = "onLoadingHide";
		
		public function Dispatcher()
		{
			// CONSTRUCTOR
		}
		
		protected function dispacha(event:String):void
		{
			dispatchEvent(new Event(event));
		}
		
		public function upload():void { dispacha(ON_UPLOAD); }
		public function uploadComplete():void { dispacha(ON_UPLOAD_COMPLETE); }
		public function loading(valor:Boolean = false):void
		{
			(valor) ? dispacha(ON_LOADING_SHOW) : dispacha(ON_LOADING_HIDE);
		}
	}
}