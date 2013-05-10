package lagden.ui
{
	import app.Application;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import lagden.utils.TxtBox;
	
	import org.casalib.display.CasaBitmap;
	import org.casalib.display.CasaSprite;
	import org.casalib.util.AlignUtil;
	import org.casalib.util.NavigateUtil;
	import org.casalib.util.StageReference;
	
	public class Footer extends CasaSprite
	{
		protected var _app:Application;
		
		private var _sesc:Sesc;
		private var _circo:Circos;
		private var _txtA:TxtBox;
		private var _txtB:TxtBox;
		private var _txtC:TxtBox;
		private var _txtD:TxtBox;
		private var _txtE:TxtBox;
		private var _txtF:TxtBox;
		
		private var _bw:uint = 760;
		private var _bh:uint = 250;
		private var _link:String = 'http://sescsp.org.br/circos';
		
		public var st:Stage;
		
		public function Footer()
		{
			this.st = StageReference.getStage();
			this._app = Application.getInstance();
			
			// Base
			this.graphics.beginFill(0x212121,1);
			this.graphics.drawRect(0,0,_bw,_bh);
			this.graphics.endFill();
			
			this.addEventListener(Event.ADDED_TO_STAGE,begin);
		}
		
		private function begin(e:Event):void
		{
			var padding:uint = 20;
			var marginBottom:uint = 15;
			
			_sesc = new Sesc();
			_circo = new Circos();
			
			var txt:Array = [
				"SESC SÃO PAULO APRESENTA:"
				, "<b>Espetáculos nacionais e internacionais • Workshop • Mesas de discussão<br>Encontros • Intervenções sobre a arte circense em 7 unidades do Sesc.</b>"
				, "Belenzinho • Bom Retiro • Ipiranga • Itaquera • Pinheiros • Santana • Santo André"
				, "DE 02 A 12 DE MAIO DE 2013"
				, 'Programação completa em <a href="' + _link + '" target="_blank">' + _link + '</a>'
				, "<b>Ingressos à venda pela rede INGRESSOSESC</b>"
			];

			
			_txtA = new TxtBox(
				txt[0]
				, "left"
				, 0xF38231
				, 20
				, _app['objs']['font_a']['family']
			);
			
			_txtB = new TxtBox(
				txt[1]
				, "none"
				, 0x777777
				, 10
				, "Verdana"
			);
			_txtB.width = 430;
			_txtB.multiline = true;
			_txtB.wordWrap = true;
			
			_txtC = new TxtBox(
				txt[2]
				, "none"
				, 0x777777
				, 10
				, "Verdana"
			);
			_txtC.width = 430;
			_txtC.multiline = true;
			_txtC.wordWrap = true;
			
			_txtD = new TxtBox(
				txt[3]
				, "left"
				, 0xF38231
				, 14
				, _app['objs']['font_a']['family']
			);
			
			_txtE = new TxtBox(
				txt[4]
				, "left"
				, 0x777777
				, 10
				, "Verdana"
			);
			
			_txtF = new TxtBox(
				txt[5]
				, "left"
				, 0x777777
				, 10
				, "Verdana"
			);
			
			AlignUtil.alignBottomLeft(_sesc,new Rectangle(0,0,_bw,_bh));
			_sesc.x += padding;
			_sesc.y -= padding;
			
			AlignUtil.alignMiddleRight(_circo,new Rectangle(0,0,_bw,_bh));
			_circo.x -= padding;
			
			_txtA.x = _txtB.x = _txtC.x = _txtD.x = _txtE.x = _txtF.x = padding;
			
			_txtA.y = padding;
			_txtB.y = _txtA.y + marginBottom + 15;
			_txtC.y = _txtB.y + marginBottom + 20;
			_txtD.y = _txtC.y + marginBottom + 10;
			_txtE.y = _txtD.y + marginBottom + 10;
			_txtF.y = _txtE.y + marginBottom + 10;
			
			addChild(_sesc);
			addChild(_circo);
			addChild(_txtA);
			addChild(_txtB);
			addChild(_txtC);
			addChild(_txtD);
			addChild(_txtE);
			addChild(_txtF);
			
			_txtE.selectable = true;
		}
	}
}
