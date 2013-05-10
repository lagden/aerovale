package lagden.ui
{
	import app.Application;
	
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import lagden.utils.TxtBox;
	
	import org.casalib.display.CasaSprite;
	import org.casalib.util.AlignUtil;
	import org.casalib.util.StageReference;
	
	public class Amigo extends CasaSprite
	{
		protected var _app:Application;
		
		private var _ribbon:RibbonAmigo;
		private var _mask:MascaraAmigo;
		private var _arc:ArcoAmigo;
		private var _txtA:TxtBox;
		private var _txtB:TxtBox;
		private var _txtC:TxtBox;
		private var _bmp:CasaSprite;
		private var _obj:Object;
		
		public var st:Stage;
		
		public function Amigo(o:Object)
		{
			this.st = StageReference.getStage();
			this._app = Application.getInstance();
			this._obj = o;
			
			// Base
			this.graphics.beginFill(0x000000,0);
			this.graphics.drawRect(0,0,260,200);
			this.graphics.endFill();
			
			this.addEventListener(Event.ADDED_TO_STAGE,begin);
		}
		
		private function begin(e:Event):void
		{
			_ribbon = new RibbonAmigo();
			_ribbon.y = 145;
			
			_mask = new MascaraAmigo();
			
			_bmp = new CasaSprite();
			_bmp.addChild(Bitmap(_obj["image"].contentAsBitmap));
			_bmp.mask = _mask;
			
			_arc = new ArcoAmigo();
			
			_txtA = new TxtBox(
				_obj["name"].toUpperCase()
				, "left"
				, _app['objs']['font_a']['color']
				, _app['objs']['font_a']['size']
				, _app['objs']['font_a']['family']
			);
			
			_txtB = new TxtBox(
				_obj["frase"].toUpperCase()
				, "none"
				, 0xDF6824
				, 14
				, _app['objs']['font_a']['family']
				, null
				, "center"
			);
			_txtB.width = 130;
			_txtB.multiline = true;
			_txtB.wordWrap = true;
			
			_txtC = new TxtBox(
				_obj["complemento"].toUpperCase()
				, "none"
				, 0x000000
				, 16
				, _app['objs']['font_a']['family']
				, null
				, "center"
			);
			_txtC.width = 210;
			_txtC.multiline = true;
			_txtC.wordWrap = true;
			
			AlignUtil.alignTopCenter(_bmp,new Rectangle(0,0,_ribbon.width,0));
			AlignUtil.alignTopCenter(_mask,new Rectangle(0,0,_ribbon.width,0));
			AlignUtil.alignMiddleCenter(_arc,new Rectangle(0,0,_ribbon.width,_mask.height));
			AlignUtil.alignMiddleCenter(_txtA,new Rectangle(0,_ribbon.y,_ribbon.width,35));
			AlignUtil.alignMiddleCenter(_txtB,new Rectangle(0,_ribbon.y + _ribbon.height,_ribbon.width,35));
			AlignUtil.alignMiddleCenter(_txtC,new Rectangle(0,_ribbon.y + _ribbon.height,_ribbon.width,35));
			
			_txtB.y += 30 - 5;
			_txtC.y += 70 - 5;
			
			addChild(_mask);
			addChild(_bmp);
			addChild(_arc);
			addChild(_ribbon);
			addChild(_txtA);
			addChild(_txtB);
			addChild(_txtC);
		}
	}
}