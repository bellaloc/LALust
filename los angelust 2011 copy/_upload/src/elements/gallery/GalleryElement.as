package elements.gallery
{
	import adobe.utils.CustomActions;
	import caurina.transitions.Tweener;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class  GalleryElement extends MovieClip
	{
		private var _persents:TextField;
		
		private var _preloader:MovieClip;
		private var _mask:MovieClip = new MovieClip();
		public var _conent:MovieClip;
		
		private var _ratio:Number;
		
		private var _data:String;
		
		public var conentHolder:MovieClip;
		public var skalingKoeff:Number;
		public var loaderCont:Loader = new Loader();
		public var loaded:Boolean = false;
		public var showed:Boolean = false;
		public var iconDrag:MovieClip;
		
		public function GalleryElement(string:String):void
		{
			_data = string;
			//trace(loaderCont.contentLoaderInfo.contentType)
			addEventListener(Event.ADDED_TO_STAGE, addHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
		}
		
		private function addHandler(e:Event):void
		{
			_preloader = GalleryBigPics(parent).getChildByName("preloaderClip") as MovieClip;
			_persents = GalleryBigPics(parent).getChildByName("preloadTxt") as TextField;
			_persents.autoSize = "left";
			
			conentHolder = getChildByName("contentClip") as MovieClip;
			_conent = conentHolder.getChildByName("cont") as MovieClip;
			
			loaderCont.load(new URLRequest(_data));
			_conent.addChild(loaderCont);
			loaderCont.contentLoaderInfo.addEventListener(Event.COMPLETE, picCompleteHandler);
			loaderCont.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, picProgressHandler);
			
			this.addChild(_mask);
			this.mask = _mask;
			iconDrag = getChildByName("icoDrag") as MovieClip;
			iconDrag.alpha = 0;
		}
		
		private function removeHandler(e:Event):void
		{
			dispatchEvent(new Event("unload",true));
			stage.removeEventListener(Event.RESIZE, resizePicHandler);
		}
		
		private function picCompleteHandler(e:Event):void
		{
			Tweener.addTween(_preloader, { alpha:0, time:0.5 } );
			Tweener.addTween(_persents, { alpha:0, time:0.5 } );
			
			//trace(loaderCont.contentLoaderInfo.contentType)
			
			loaded = true;
			
			Bitmap(loaderCont.contentLoaderInfo.content).smoothing = true;
			
			_ratio = loaderCont.contentLoaderInfo.width / loaderCont.contentLoaderInfo.height;
			
			if (stage)
			{
				stage.addEventListener(Event.RESIZE, resizePicHandler);
				skalingKoeff = resizePicHandler(null);
			}
			
			gotoAndPlay("open");
			
			var limitWidth:uint = stage.fullScreenHeight;
			var limitHeight:uint = stage.fullScreenHeight;
			
			if (limitWidth == 0)
			{
				limitWidth = uint(stage.stageWidth);
				limitHeight = uint(stage.stageHeight);
			}
			
			for (var i:uint = 0; i < Math.ceil(limitWidth / 72); i++ )
			{
				for (var j:uint = 0; j < Math.ceil(limitHeight / 72); j++ )
				{
					var maskEll:MaskEll = new MaskEll();
					maskEll.x = i * 72;
					maskEll.y = j * 72;
					_mask.addChild(maskEll);
					maskEll.gotoAndPlay(2);
				}
			} 
			dispatchEvent(new Event("loaded", true));
		}
		
		private function picProgressHandler(e:ProgressEvent):void
		{
			var pers:Number = Math.round(100 * loaderCont.contentLoaderInfo.bytesLoaded / loaderCont.contentLoaderInfo.bytesTotal);
			_persents.htmlText = String(pers) +"%";
		}
		
		public function resizePicHandler(e:Event):Number
		{
			var stageRatio:Number;
			stageRatio = stage.stageWidth / stage.stageHeight;
			
			_conent.scaleX = 1;
			_conent.scaleY = 1;
			
			var koef:Number;
			
			if (stageRatio > _ratio)
			{
				koef = stage.stageWidth / loaderCont.contentLoaderInfo.content.width;
				_conent.scaleX = koef;
				_conent.scaleY = koef;
			}
			else
			{
				koef = stage.stageHeight / loaderCont.contentLoaderInfo.content.height;
				_conent.scaleX = koef;
				_conent.scaleY = koef;
			}
			skalingKoeff = koef;
			return koef;
		}
	}
	
}