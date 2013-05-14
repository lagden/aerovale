package app.events
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class Dispatcher extends EventDispatcher
	{
		public const ON_ORIGEM:String = "onOrigem";
		public const ON_DESTINO:String = "onDestino";
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
		
		public function origem():void { dispacha(ON_ORIGEM); }
		public function destino():void { dispacha(ON_DESTINO); }
		public function loading(valor:Boolean = false):void
		{
			(valor) ? dispacha(ON_LOADING_SHOW) : dispacha(ON_LOADING_HIDE);
		}
	}
}