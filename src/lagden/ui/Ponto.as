package lagden.ui
{
	import app.Application;
	import app.events.Dispatcher;
	
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.hybrid.ui.ToolTip;
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	
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
		private var _handler:CasaSprite;
		private var _tooltip:ToolTip;
		
		public var code:String = null;
		public var isOrigem:Boolean = false;
		public var isDestino:Boolean = false;
		
		public var cor:uint = 0x13bace;
		public var lineSize:uint = 2;
		
		public var st:Stage;
		
		protected var _destinos:Object = {};
		
		public function Ponto(n:String, d:Dispatcher)
		{
			this.mouseChildren = true;
			
			this.code = n;
			this.st = StageReference.getStage();
			this._app = Application.getInstance();
			this._dispatcher = d;
			
			this._pontoAmarelo = new pontoAmarelo();
			this._pontoAzul = new pontoAzul();
			this._pontoAzul.alpha = 0;
			
			var glow:GlowFilter = new GlowFilter(cor - 5);
			this._pino = new Pino();
			this._pino.visible = false;
			this._pino.alpha = 0;
			this._pino.filters = [glow];
			
			this._content = new CasaSprite();
			
			this._tooltip = new ToolTip();
			
			var tf:TextFormat = new TextFormat();
			tf.bold = true;
			tf.size = 12;
			tf.color = 0xFFFFFF;
			
			this._tooltip.hook = true;
			this._tooltip.cornerRadius = 0;
			this._tooltip.autoSize = true;
			this._tooltip.colors = [0x000000, 0x000000];
			this._tooltip.bgAlpha = .7;
			this._tooltip.align = "center";
			this._tooltip.titleFormat = tf;
			
			this._handler = new CasaSprite();
			this._handler.buttonMode = true;
			with(this._handler.graphics){
				beginFill(0x000000, 0);
				drawRect(-this._pino.width/2, -this._pino.height/2, this._pino.width, this._pino.height);
				endFill();
			}
			this._handler.addEventListener(MouseEvent.MOUSE_OVER, this.showTooltip);
			
			this.addChild(this._content);
			this.addChild(this._pontoAmarelo);
			this.addChild(this._pontoAzul);
			this.addChild(this._pino);
			this.addChild(this._handler);
			
			this.x = this._app['objs']['cidades'][this.code].coords.lon;
			this.y = this._app['objs']['cidades'][this.code].coords.lat;
			
			this.addEventListener(Event.ADDED_TO_STAGE,begin);
		}
		
		private function showTooltip(e:MouseEvent):void
		{
			this._tooltip.show(this._handler, this._app['objs']['cidades'][this.code]['nome'] );
		}
		
		// Prepara o ponto e seus destinos
		private function begin(e:Event):void
		{
			
			for(var d:String in this._app['objs']['flights'][this.code])
			{
				var n:String = String(this._app['objs']['flights'][this.code][d]);
				var destino:Object = {};
				destino['code'] = n;
				destino['mc'] = new CasaSprite();
				destino['line'] = new CasaShape();
				with (destino['line'].graphics) {
					clear();
					lineStyle(this.lineSize, this.cor, 1);
					moveTo(0,0);
				};
				destino['lat'] = this._app['objs']['cidades'][n].coords.lat;
				destino['lon'] = this._app['objs']['cidades'][n].coords.lon;
				this._destinos[n] = destino;
				
				this._content.addChild(this._destinos[n].mc);
				this._content.addChild(this._destinos[n].line);
			}
			
			this._handler.addEventListener(MouseEvent.CLICK, this.all);
			this._dispatcher.addEventListener(_dispatcher.ON_ORIGEM, this.origem);
			this._dispatcher.addEventListener(_dispatcher.ON_DESTINO, this.destino);
			this._dispatcher.addEventListener(_dispatcher.ON_LIGADO, this.ligado);
			this._dispatcher.addEventListener(_dispatcher.ON_DESLIGADO, this.desligado);
		}
		
		// onClick - Mostra todos os destinos do ponto
		private function all(e:MouseEvent):void
		{
			this._app['objs']['origem'] = this.code;
			this._app['objs']['destino'] = null;
			this._dispatcher.origem();
			
			// Executa o javascript
			ExternalInterface.call("destinosDe", this._app['objs']['origem']);
		}
		
		// listener da origem - Faz as animações das linhas e pontos
		private function origem(e:Event):void
		{
			this._dispatcher.swap();
			this._dispatcher.trigger(false);
			
			this._handler.visible = false;
			this.isDestino = false;
			
			this.cleanup();
			
			// Verifica se é o ponto de origem
			this.isOrigem = (this.code == this._app['objs']['origem']);
			if(this.isOrigem)
			{
				TweenMax.to(this._pontoAzul, .5, {alpha: 1, onComplete: alphaPonto, onCompleteParams:[this._pontoAmarelo]});
				
				// Pino
				this._pino.visible = true;
				TweenMax.fromTo(this._pino, .5, {y: -5, alpha: 0}, {y: 0, alpha: 1, delay: 1.5, onComplete: trigger});
				
				// Destinos
				var tlLines:TimelineMax = new TimelineMax();
				
				// Somente 1 destino
				if(this._app['objs']['destino'] != null && ObjectUtil.contains(this._destinos, this._destinos[this._app['objs']['destino']]))
				{
					var n:String = String(this._app['objs']['destino']);
					tlLines.add(
						TweenMax.to(
							this._destinos[n].mc, 1, {
								x: this._destinos[n].lon - this.x,
								y: this._destinos[n].lat - this.y,
								onUpdate: drawLine,
								onUpdateParams: [this._destinos[n].line, this._destinos[n].mc],
								onComplete: pontoDestino,
								onCompleteParams: [n]
							}
						)
					);
				}
				// Todos os destinos
				else
				{
					for each (var d:Object in this._destinos)
					{
						var destinosTweens:Array = [];
						destinosTweens.push(
							TweenMax.to(
								d.mc, 1, {
									x: d.lon - this.x,
									y: d.lat - this.y,
									onUpdate: drawLine,
									onUpdateParams: [d.line, d.mc],
									onComplete: pontoDestino,
									onCompleteParams: [d.code]
								}
							)
						);
					}
					tlLines = new TimelineMax();
					tlLines.insertMultiple(destinosTweens, 0, TweenAlign.START, 0.2);
				}
			}
			// se não reseta o ponto
			else
			{
				if(this._pontoAmarelo.alpha == 0)
				{
					TweenMax.to(this._pontoAmarelo, .5, {alpha: 1});
					TweenMax.to(this._pontoAzul, .5, {delay: .5, alpha: 0});
					TweenMax.to(this._content, .5, { alpha: 0, onComplete: cleanup});
					TweenMax.to(this._pino, .5, { alpha: 0});
				}
			}
		}
		
		// onComplete - Seta como destino e dispara evento
		public function pontoDestino(n:String):void
		{
			this._app['objs']['pontos'][n].isDestino = true;
			this._dispatcher.destino();
		}
		
		// listener do destino - Deixa o ponto azul quando a linha chegar
		private function destino(e:Event):void
		{
			if(this.isDestino)
			{
				TweenMax.to(this._pontoAmarelo, .5, {delay: .5,alpha: 0});
				TweenMax.to(this._pontoAzul, .5, {alpha: 1});
			}
		}
		
		// onComplete - Habilita o click do handler
		private function trigger():void
		{
			this._dispatcher.trigger(true);
		}
		
		// listener do trigger - Handler click
		private function ligado(e:Event):void
		{
			this.enableHandler(true);
		}
		
		// listener do trigger - Handler click
		private function desligado(e:Event):void
		{
			this.enableHandler(false);
		}
		
		// helper - Handler click
		private function enableHandler(v:Boolean):void
		{
			this._handler.visible = v;	
		}
		
		// onComplete - Reset das linhas
		private function cleanup():void
		{
			for each (var d:Object in this._destinos)
			{
				d.mc.x = d.mc.y = d.line.x = d.line.y = 0;
				with (d.line.graphics) {
					clear();
					lineStyle(this.lineSize, this.cor, 1);
					moveTo(0,0);
				};
			}
			this._content.alpha = 1;
		}
		
		// onComplete - Zera o alpha do MovieClip
		private function alphaPonto(mc:MovieClip):void
		{
			mc.alpha = 0;
		}
		
		// onUpdate - Desenha a linha
		private function drawLine(line:CasaShape, mc:CasaSprite):void
		{
			line.graphics.lineTo(mc.x,mc.y);
		}
	}
}