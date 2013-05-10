package lagden
{
	import app.Application;
	import app.events.Dispatcher;
	
	import com.adobe.images.JPGEncoder;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import org.casalib.events.LoadEvent;
	import org.casalib.load.DataLoad;
	import org.casalib.util.ObjectUtil;
	import org.casalib.util.DateUtil;
	
	import ru.inspirit.net.MultipartURLLoader;
	import ru.inspirit.net.events.MultipartURLLoaderEvent;

	public class Servico
	{	
		protected var _app:Application;
		protected var _dispatcher:Dispatcher;
		
		protected var _dataLoad:DataLoad;
		protected var _multi:MultipartURLLoader;
		
		public function Servico(d:Dispatcher)
		{
			this._app = Application.getInstance();
			this._dispatcher = d;
			
			// Upload
			this._multi = new MultipartURLLoader();;
			
			// Escuta os eventos de upload
			this._dispatcher.addEventListener(_dispatcher.ON_UPLOAD, this.onUpload);
		}
		
		// BEGIN Upload Stuff
		private function onUpload(e:Event):void
		{
			trace('onUpload');
			
			if(this._app['objs']['upload'] != null && this._app['objs']['snapShot'] != null)
			{
				// Dispara o evento para mostrar o loading
				this._dispatcher.loading(true);
				
				// Verifica se o snapShot foi disparado
				var hasImage:Boolean = ( getQualifiedClassName(this._app['objs']['snapShot']) == 'flash.utils::ByteArray' ) ? true : false;
				
				// Posta os dados
				this._multi.dataFormat = URLLoaderDataFormat.TEXT;
				this._multi.addEventListener(Event.COMPLETE, this.onCompleteUpload);
				
				// Limpa antes
				this._multi.clearFiles();
				this._multi.clearVariables();
				
				// Verifica se tem o snapShot
				if(hasImage)
					_multi.addFile(this._app['objs']['snapShot'], 'circo' + this._app['objs']['dono'] + DateUtil.formatDate(new Date(), "U") + '.jpg', 'Upload[capa]', 'image/jpeg');
				
				this._multi.addVariable('tags', String(JSON.stringify(this._app['objs']['tags'])));
				this._multi.load(this._app['objs']['upload'], false);	
			}
			else
				trace('objs nulos!');
		}
		
		protected function onCompleteUpload(e:Event):void
		{
			// Dispara o evento para remover o loading
			this._dispatcher.loading(false);
			
			// Parse na resposta
			var r:String = MultipartURLLoader(e.target).data;
			this._app['objs']['uploadResponse'] = JSON.parse(r);
			trace(r);
			
			// Limpa e remove a escuta
			this._multi.clearFiles();
			this._multi.clearVariables();
			this._multi.removeEventListener(Event.COMPLETE, this.onCompleteUpload);
			
			// Dispara o evento de upload completo
			this._dispatcher.uploadComplete();
		}
		// END Upload Stuff
		
		// Helper
		//
		// Tranforma o MovieClip em imagem jpg e encoda para ByteArray
		public static function snapShot(target:DisplayObject, w:uint, h:uint):ByteArray
		{
			var bitmapData:BitmapData = new BitmapData(w, h, true, 0xFFFFFF);
			var drawingRectangle:Rectangle =  new Rectangle(0, 0, w, h);
			bitmapData.draw(target, new Matrix(), null, null, drawingRectangle, false);
			var jpg:JPGEncoder = new JPGEncoder(80);
			return jpg.encode(bitmapData);
		}
	}
}