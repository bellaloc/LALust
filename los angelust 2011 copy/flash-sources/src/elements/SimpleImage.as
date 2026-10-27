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
	public class SimpleImage extends MovieClip
	{
		private var _conent:MovieClip;
		private var _loader:Loader = new Loader();
		
		public function SimpleImage():void
		{
			var _contentClip:MovieClip = getChildByName("contentClip") as MovieClip;
			_conent = _contentClip.getChildByName("cont") as MovieClip;
			
		}
		
		public function init(data:XML):void
		{
			var nameSt:String = String(data);
			_loader.load(new URLRequest(nameSt));
			_conent.addChild(_loader);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, picCompleteHandler);
			
			setKoord(Number(data.@x), Number(data.@y));
			setSize(Number(data.@width), Number(data.@height));
		}
		
		protected function picCompleteHandler(e:Event):void
		{
			gotoAndPlay("start");
			Bitmap(_loader.contentLoaderInfo.content).smoothing = true; 
		}
		
		public function setSize(inWidth:Number, inHeight:Number):void
		{

		}
		
		public function setKoord(newX:Number, newY:Number):void
		{
			x = newX;
			y = newY;
		}
	}
	
}