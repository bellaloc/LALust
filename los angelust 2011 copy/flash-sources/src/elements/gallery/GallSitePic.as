package elements.gallery
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
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import MainDocument;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class GallSitePic extends MovieClip
	{
		private var _preloader:MovieClip;
		private var _loader:Loader = new Loader();
		private var _mask:MovieClip;
		private var _conent:MovieClip;
		private var _area:MovieClip;
		private var _tf:TextField;
		
		public var number:uint = 0;
		private var _selected:Boolean = false;
		
		public function GallSitePic():void
		{
			_preloader = getChildByName("preloaderClip") as MovieClip;
			_area = getChildByName("areaClip") as MovieClip;
			_mask = getChildByName("maskClip") as MovieClip;
			_conent = contentClip.getChildByName("cont") as MovieClip;
			_tf = textHolder.texts.getChildByName("tf") as TextField;
		}
		
		public function init(nameSt:String,textSetings:XML, num:uint = 0):void
		{
			_loader.load(new URLRequest(nameSt));
			_conent.addChild(_loader);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, picCompleteHandler);
			
			_tf.htmlText = String(textSetings);
			_tf.autoSize = TextFieldAutoSize.LEFT;
			
			_area.width = _tf.textWidth + 10;
			
			if (String(textSetings.@embedFonts) == "true")
				_tf.embedFonts = true;
			
			if (num!=0)
				number = num;
		}
		
		protected function picCompleteHandler(e:Event):void
		{
			gotoAndPlay("start");
			Tweener.addTween(_preloader , { alpha:0, time:0.5 } );
			_area.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			_area.addEventListener(MouseEvent.ROLL_OUT, outHandler);
			_area.addEventListener(MouseEvent.CLICK, clickHandler);
			_area.buttonMode = true;
			
			Bitmap(_loader.contentLoaderInfo.content).smoothing = true; 
			
			parent.parent.addEventListener("nextShow", setNextHandler);
			
			if (_selected)
				overPic();
		}
		
		private function setNextHandler(e:Event):void
		{
			if (SiteGallery(e.target).curentPic == number)
			{
				overPic();
				setSelected()
				dispatchEvent(new Event("newSlide", true, true));
			}
		}
		
		public function setSelected():void
		{
			_selected = true;
		}
		
		public function setUnselected():void
		{
			_selected = false;
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
			if(!_selected)
				overPic();
		}
		protected function outHandler(e:MouseEvent):void
		{
			if(!_selected)
				outPic();
		}
		protected function clickHandler(e:MouseEvent):void
		{
			if (!_selected)
			{
				setSelected();
				var thumbEvent:Event = new Event("thumbSelected", true, true);
				dispatchEvent(thumbEvent);
			}
		}
		
	}
	
}