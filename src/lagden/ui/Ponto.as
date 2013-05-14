package lagden.ui
{
	import app.Application;
	import app.events.Dispatcher;
	
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import lagden.utils.TxtBox;
	
	import org.casalib.display.CasaShape;
	import org.casalib.display.CasaSprite;
	import org.casalib.util.AlignUtil;
	import org.casalib.util.ObjectUtil;
	import org.casalib.util.StageReference;
	
	public class Ponto extends CasaSprite
	{
		protected var _app:Application;
		protected var _dispatcher:Dispatcher;
		
		private var _txtA:TxtBox;
		private var _pontoAmarelo:pontoAmarelo;
		private var _pontoAzul:pontoAzul;
		private var _pino:Pino;
		private var _content:CasaSprite;
		
		public var code:String = null;
		public var isOrigem:Boolean = false;
		
		public var st:Stage;
		
		protected var _destinos:Object = {};
		
		public function Ponto(n:String, d:Dispatcher)
		{
			this.code = n;
			this.st = StageReference.getStage();
			this._app = Application.getInstance();
			this._dispatcher = d;
			
			this._pontoAmarelo = new pontoAmarelo();
			this._pontoAzul = new pontoAzul();
			this._pontoAzul.alpha = 0;
			
			this._pino = new Pino();
			this._pino.alpha = 0;
			
			this._content = new CasaSprite();
			
			this.addChild(this._content);
			this.addChild(this._pontoAmarelo);
			this.addChild(this._pontoAzul);
			this.addChild(this._pino);
			
			this.x = this._app['objs']['cidades'][this.code].coords.lon;
			this.y = this._app['objs']['cidades'][this.code].coords.lat;
			
			this.addEventListener(Event.ADDED_TO_STAGE,begin);
		}
		
		private function begin(e:Event):void
		{
			for(var d:String in this._app['objs']['flights'][this.code])
			{
				var n:String = String(this._app['objs']['flights'][this.code][d]);
				var destino:Object = {};
				destino['mc'] = new CasaSprite();
				destino['line'] = new CasaShape();
				with (destino['line'].graphics) {
					clear();
					lineStyle(3, 0x00bdd1, 1);
					moveTo(0,0);
				};
				destino['lat'] = this._app['objs']['cidades'][n].coords.lat;
				destino['lon'] = this._app['objs']['cidades'][n].coords.lon;
				this._destinos[n] = destino;
				
				this._content.addChild(this._destinos[n].mc);
				this._content.addChild(this._destinos[n].line);
			}
			
			this._dispatcher.addEventListener(_dispatcher.ON_ORIGEM, origem);
		}
		
		private function origem(e:Event):void
		{
			this.isOrigem = (this.code == this._app['objs']['origem']);
			if(this.isOrigem)
			{
				TweenMax.to(this._pontoAzul, .5, {delay: 1, alpha: 1, onComplete: alphaPonto, onCompleteParams:[this._pontoAmarelo]});
				
				// Pino
				TweenMax.to(this._pino, .5, { delay: 1.5, alpha: 1});
				var tl:TimelineMax = new TimelineMax({repeat: 3, delay: 1.5});
				tl.add( TweenMax.to(this._pino, .5, {y: -5}) );
				tl.add( TweenMax.to(this._pino, .5, {y: 0}) );
				tl.play();
				
				// Destinos
				var tlLines:TimelineMax = new TimelineMax({delay: 1.5 * 3 });
				if(this._app['objs']['destino'] != null)
				{
					var n:String = String(this._app['objs']['destino']);
					trace(ObjectUtil.getKeys(this._destinos), this._destinos[n].lat, n, 'after');	
					tlLines.add(
						TweenMax.to(
							this._destinos[n].mc, 1, {
								x: this._destinos[n].lon - this.x,
								y: this._destinos[n].lat - this.y,
								onUpdate: drawLine,
								onUpdateParams: [this._destinos[n].line, this._destinos[n].mc]
							}
						)
					);
				}
			}
			else
			{
				if(this._pontoAmarelo.alpha == 0)
				{
					TweenMax.to(this._pontoAzul, .5, {alpha: 0});
					TweenMax.to(this._pontoAmarelo, .5, {delay: .5, alpha: 1});
				}
			}
		}
		
		private function alphaPonto(mc:MovieClip):void
		{
			mc.alpha = 0;
		}
		
		private function drawLine(line:CasaShape, mc:CasaSprite):void
		{
			line.graphics.lineTo(mc.x,mc.y);
		}
	}
}