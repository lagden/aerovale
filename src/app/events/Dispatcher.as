package app.events
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class Dispatcher extends EventDispatcher
	{
		public const ON_ORIGEM:String = "onOrigem";
		public const ON_DESTINO:String = "onDestino";
		public const ON_SWAP:String = "onSwap";
		public const ON_LIGADO:String = "onLigado"
		public const ON_DESLIGADO:String = "onDesligado";
		
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
		public function swap():void { dispacha(ON_SWAP); }
		public function trigger(valor:Boolean = false):void
		{
			(valor) ? dispacha(ON_LIGADO) : dispacha(ON_DESLIGADO);
		}
	}
}