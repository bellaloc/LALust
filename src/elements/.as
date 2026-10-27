package elements
{
	import adobe.utils.CustomActions;
	import caurina.transitions.Tweener;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import MainDocument;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class ContentImage extends MovieClip
	{
		private var _preloader:MovieClip;
		private var _loader:Loader = new Loader();
		private var _mask:MovieClip;
		private var _conent:MovieClip;
		private var _area:MovieClip;
		
		public function ContentImage():void
		{
			
			_preloader = getChildByName("preloaderClip") as MovieClip;
			_area = getChildByName("areaClip") as MovieClip;
			_mask = getChildByName("maskClip") as MovieClip;
			var _contentClip:MovieClip = getChildByName("contentClip") as MovieClip;
			_conent = _contentClip.getChildByName("cont") as MovieClip;
			
			_conent.mask = _mask;
		}
		
		public function init(data:XML):void
		{
			var nameSt:String = String(data.property.(@id == 1));
			_loader.load(new URLRequest(nameSt));
			_conent.addChild(_loader);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, picCompleteHandler);
			
			setKoord(Number(data.@x), Number(data.@y));
			setSize(Number(data.@width), Number(data.@height));
		}
		
		protected function picCompleteHandler(e:Event):void
		{
			gotoAndPlay("start");
			Tweener.addTween(_preloader , { alpha:0, time:0.5 } );
			//_area.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			//_area.addEventListener(MouseEvent.ROLL_OUT, outHandler);
			//_area.addEventListener(MouseEvent.CLICK, clickHandler);
			//_area.buttonMode = true;
			
			Bitmap(_loader.contentLoaderInfo.content).smoothing = true; 
		}
		
		public function setSize(inWidth:Number, inHeight:Number):void
		{
			_mask.width = inWidth;
			_mask.height = inHeight;
			
			_area.width = inWidth;
			_area.height = inHeight;
			
			_preloader.x = Math.round((_area.width -_preloader.width) / 2);
			_preloader.y = Math.round((_area.height -_preloader.height) / 2);
		}
		
		public function setKoord(newX:Number, newY:Number):void
		{
			x = newX;
			y = newY;
		}
		
		public function overPic():void
		{
			gotoAndPlay("over");
		}
		
		public function outPic():void
		{
			gotoAndPlay("out");
		}
		
		protected function overHandler(e:MouseEvent):void
		{
			overPic();
		}
		protected function outHandler(e:MouseEvent):void
		{
			outPic();
		}
	}
	
}