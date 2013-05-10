package
{
	import app.Application;
	import app.events.Dispatcher;
	
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.system.Security;
	import flash.system.System;
	
//	import lagden.Base64;
//	import lagden.Servico;
//	import lagden.ui.Amigo;
//	import lagden.ui.Dono;
//	import lagden.ui.Footer;
	
	import org.casalib.display.CasaSprite;
	import org.casalib.events.LoadEvent;
	import org.casalib.load.DataLoad;
	import org.casalib.util.AlignUtil;
	import org.casalib.util.FlashVarUtil;
	import org.casalib.util.StageReference;
	
	[SWF(width="760", height="1190", backgroundColor="#000000", frameRate="31")]
	
	public class Aerovale extends CasaSprite
	{
		protected var _app:Application;
		protected var _dispatcher:Dispatcher;
		
//		protected var _servico:Servico;
		
		protected var _dataLoad:DataLoad;			
		protected var _dados:Object;
		
		private var _master:CasaSprite;
			
		public function Aerovale()
		{
			super();
			
			// Security
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			// Stage
			StageReference.setStage(this.stage);
			this.stage.scaleMode=StageScaleMode.NO_SCALE;
			this.stage.align=StageAlign.TOP_LEFT;
			
			// Variáveis e Eventos globais  
			this._app = Application.getInstance();
			this._dispatcher = new Dispatcher();
			
			this._app['objs'] = {};
			this._app['objs']['w'] = 760;
			this._app['objs']['h'] = 1190;	
		}
	}
}