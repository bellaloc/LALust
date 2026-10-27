package 
{
	import adobe.utils.CustomActions;
	import caurina.transitions.Tweener;
	import elements.popup.SitePopup;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TextEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	
	import flash.external.ExternalInterface;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class MainDocument extends MovieClip 
	{
		private static var contentData:XML = new XML();
		private static var mainTimeline:MovieClip;
		public static var rootLink:uint = 0;
		public static var rootGall:uint = 1;
		public static var previosLink:uint = 0;
		
		public var myRequest:URLRequest = new URLRequest("text.xml");
		public var loaderXML:URLLoader = new URLLoader(myRequest);
		public var siteLoader:Loader = new Loader();
		
		private var _textLoder:TextField;
		private var _mc:MovieClip;
		private var container:MovieClip
		
		public function MainDocument():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			container = MovieClip(getChildByName("cont"));
			
			_textLoder = container.getChildByName("txt") as TextField;
			_mc = container.getChildByName("mc") as MovieClip;
			
			_textLoder.autoSize = TextFieldAutoSize.LEFT;
			
			_textLoder.text = "loading data"
			
			loaderXML.addEventListener(Event.COMPLETE, xmlLoadingCompleteHandler);
			loaderXML.addEventListener(ProgressEvent.PROGRESS, xmlProgressHandler);
			
			stage.addEventListener(Event.RESIZE, resizeHandler);
			
			stop();
			
			resizeHandler(null);
			
		}
		private function resizeHandler(e:Event):void
		{
			container.x = Math.round((stage.stageWidth - container.width) / 2);
			container.y = Math.round((stage.stageHeight - container.height) / 2);
		}
		
		private function xmlLoadingCompleteHandler(e:Event):void
		{
			contentData = XML(URLLoader(e.target).data);
			//trace("textName " + contentData.page.@name);
			//trace("textData " + contentData.page.txt[0]);
			
			//trace("textData " + contentData.page.(@id == 2).txt[0]);
			//trace("Page name " + contentData.page.(@id == 2).@name);
			
			// remove event listeners
			
			loaderXML.removeEventListener(Event.COMPLETE, xmlLoadingCompleteHandler);
			loaderXML.removeEventListener(ProgressEvent.PROGRESS, xmlProgressHandler);
			
			siteLoader.load(new URLRequest("website.swf"));
			
			addChild(siteLoader);
			setChildIndex(siteLoader, 0);
			
			_textLoder.text = "loading graphics"
			
			siteLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, siteCompleteHandler);
			siteLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, siteProgressHandler);
			
		}
		
		private function xmlProgressHandler(e:Event):void
		{
			var persents:Number = Math.round((loaderXML.bytesLoaded / loaderXML.bytesTotal)*100);
			_textLoder.text = "loading data " + String(persents) + "%";
			_mc.width = persents;
			
		}
		
		private function siteCompleteHandler(e:Event):void
		{
			Tweener.addTween(container, { alpha:0, time:0.5, transition:"easeOutExpo" } );
			stage.removeEventListener(Event.RESIZE, resizeHandler);
			
			mainTimeline = LoaderInfo(e.target).content as MovieClip;
			mainTimeline.play();
			play();
		}
		
		private function siteProgressHandler(e:ProgressEvent):void
		{
			var persents:Number = Math.round((siteLoader.contentLoaderInfo.bytesLoaded / siteLoader.contentLoaderInfo.bytesTotal)*100);
			_textLoder.text = "loading graphics " + String(persents) + "%";
			_mc.width = persents;
		}

		
		// public metids for all website
		
		public static function getMainTimline():MovieClip
		{
			if (mainTimeline)
				return mainTimeline;
			else
				return null;
		}
		
		public static function getData():XML
		{
			if (contentData)
				return contentData;
			else
				return null;
		}
		
	}
	
}