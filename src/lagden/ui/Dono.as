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
	
	public class Dono extends CasaSprite
	{
		protected var _app:Application;
		
		private var _ribbon:RibbonDono;
		private var _mask:MascaraDono;
		private var _arc:Coroa;
		private var _txtA:TxtBox;
		private var _bmp:CasaSprite;
		private var _obj:Object;
		
		public var st:Stage;
		
		public function Dono(o:Object)
		{
			this.st = StageReference.getStage();
			this._app = Application.getInstance();
			this._obj = o;
			
			// Base
			this.graphics.beginFill(0x000000,0);
			this.graphics.drawRect(0,0,349,250);
			this.graphics.endFill();
			
			this.addEventListener(Event.ADDED_TO_STAGE,begin);
		}
		
		private function begin(e:Event):void
		{
			_ribbon = new RibbonDono();
			_ribbon.y = 160;
			
			_mask = new MascaraDono();
			_mask.cacheAsBitmap = true;
			
			_bmp = new CasaSprite();
			_bmp.addChild(Bitmap(_obj["image"].contentAsBitmap));
			_bmp.cacheAsBitmap = true;
			_bmp.mask = _mask;
			
			_arc = new Coroa();
			
			_txtA = new TxtBox(
				_obj["name"].toUpperCase()
				, "left"
				, 0x212121
				, 27
				, _app['objs']['font_a']['family']
			);
			
			AlignUtil.alignTopCenter(_bmp,new Rectangle(0,0,_ribbon.width,0));
			AlignUtil.alignTopCenter(_mask,new Rectangle(0,0,_ribbon.width,0));
			AlignUtil.alignMiddleCenter(_arc,new Rectangle(0,0,_ribbon.width,_mask.height));
			AlignUtil.alignMiddleCenter(_txtA,new Rectangle(0,_ribbon.y,_ribbon.width,35));
			_txtA.y += 7;
			
			addChild(_mask);
			addChild(_bmp);
			addChild(_arc);
			addChild(_ribbon);
			addChild(_txtA);
		}
	}
}