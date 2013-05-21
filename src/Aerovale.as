package
{
	import app.Application;
	import app.events.Dispatcher;
	
	import com.greensock.TweenMax;
	
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.system.Security;
	import flash.system.System;
	
	import lagden.ui.Ponto;
	
	import org.casalib.display.CasaSprite;
	import org.casalib.events.LoadEvent;
	import org.casalib.load.DataLoad;
	import org.casalib.time.Interval;
	import org.casalib.util.AlignUtil;
	import org.casalib.util.FlashVarUtil;
	import org.casalib.util.LocationUtil;
	import org.casalib.util.ObjectUtil;
	import org.casalib.util.StageReference;
	
	[SWF(width="700", height="670", backgroundColor="#000000", frameRate="50")]
	
	public class Aerovale extends CasaSprite
	{
		protected var _app:Application;
		protected var _dispatcher:Dispatcher;
		
		protected var _dataLoad:DataLoad;			
		protected var _dados:Object;
		
		private var _bgMapa:bgMapa;
		private var _mapa:Mapa;
		
		private var _delay:Number = 0;
			
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
			this._app['objs']['w'] = 700;
			this._app['objs']['h'] = 670;
			this._app['objs']['origem'] = null;
			this._app['objs']['destino'] = null;
			
			// Json - Dados
			var dados:String = (LocationUtil.isWeb(this.stage)) ? "../Documents/data/dadosJuninho.js" : "data/dadosJuninho.js";
			
			this._dataLoad = new DataLoad(dados);			
			this._dataLoad.addEventListener(IOErrorEvent.IO_ERROR, this._onError);
			this._dataLoad.addEventListener(LoadEvent.COMPLETE, this._onComplete);
			this._dataLoad.start();
			
			this._bgMapa = new bgMapa();
			this._bgMapa.alpha = 0;
			this._bgMapa.addEventListener(Event.ADDED_TO_STAGE,anima);
			this.addChild(this._bgMapa);
			
			//*
			this._mapa = new Mapa();
			this._mapa.alpha = 0;
			this._mapa.addEventListener(Event.ADDED_TO_STAGE,anima);
			AlignUtil.alignMiddleCenter(this._mapa, new Rectangle(0, 0, this._app['objs']['w'], this._app['objs']['h']));
			var mapa:* = this._mapa.getChildAt(0);
			mapa.alpha = 0;
			this.addChild(this._mapa);
			//*/
			
			// Helper para fazer o mapeamento (Dev)
			 this.addEventListener(MouseEvent.MOUSE_MOVE,coords);
		}
		
		private function coords(e:MouseEvent):void{
//			trace(e.localX, e.localY);
		}
		
		private function anima(e:Event):void
		{
			_delay += .5;
			TweenMax.to(e.target, .5, {delay:_delay, alpha: 1});
			e.target.removeEventListener(Event.ADDED_TO_STAGE,anima);
		}
		
		protected function _onError(e:IOErrorEvent):void
		{
			trace("There was an error - Group Images");
			trace(e.text);
		}
		
		protected function _onComplete(e:LoadEvent):void
		{			
			this._dados = JSON.parse(this._dataLoad.dataAsString);
			
			// Parse e adiciona pontos no no mapa
			this._app['objs']['pontos'] = {};
			if(ObjectUtil.contains(this._dados,this._dados.cidades) && ObjectUtil.contains(this._dados,this._dados.voos))
			{
				var parseCidades:Object = {};
				for each (var cidade:Object in this._dados.cidades)
					parseCidades[cidade.sigla] = {
						"nome": cidade.nome,
						"coords": {
							"lat": cidade.lat,
							"lon": cidade.lon
						}
					};

				var parseFlights:Object = {};
				for each (var flight:Object in this._dados.voos)
					parseFlights[flight.origem] = flight.destinos;

				this._app['objs']['cidades'] = parseCidades;
				this._app['objs']['flights'] = parseFlights;
				
				for(var i:String in parseCidades)
				{
					trace('Local:', i);
					this._app['objs']['pontos'][i] = new Ponto(i, this._dispatcher); 
					this._mapa.addChild(this._app['objs']['pontos'][i]);
				}
			}
			trace("Data has loaded.");
			this._dataLoad.destroy();
			
			this._dispatcher.addEventListener(_dispatcher.ON_SWAP, swap);
			
			// Filtro via javascript
			ExternalInterface.addCallback("origemDestino", filtro);
		}
		
		// Dispara o filtro
		private function filtro(o:String, d:String):void
		{
			this._app['objs']['origem'] = o;
			this._app['objs']['destino'] = d;
			this._dispatcher.origem();
		}
		
		// Troca a posição
		private function swap(e:Event):void
		{
			//*
			if(this._app['objs']['origem'] != null)
			{
				var o:String = this._app['objs']['origem'];
				if(ObjectUtil.contains(this._app['objs']['pontos'],this._app['objs']['pontos'][o]))
				{
					var pos:int = this._mapa.getChildIndex(this._app['objs']['pontos'][o]);
					if(pos > 1)
					{
						this._mapa.swapChildrenAt(1, pos);
					}
				}
			}
			//*/
		}
	}
}