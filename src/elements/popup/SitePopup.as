package elements.popup
{
	import adobe.utils.CustomActions;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class  SitePopup extends MovieClip
	{
		private var _bg:MovieClip;
		private var _contentHolder:MovieClip;
		private var _content:MovieClip;
		private var _close:MovieClip;
		
		public function SitePopup():void
		{
			_bg = bg.getChildByName("bg") as MovieClip;
			_contentHolder = getChildByName("contentHolder") as MovieClip;
			_content = _contentHolder.getChildByName("content") as MovieClip;
			_close = _contentHolder.getChildByName("closePopup") as MovieClip;
			
			addEventListener(Event.ADDED_TO_STAGE, addHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, remooveHandler);
		}
		// adding content too popup
		public function DataInit(dataXML:XML):void
		{
			WebSite.getContentFpomBlock(dataXML.contentBlock.(@id == 1), _content);
			//trace(dataXML.@id);
		}
		
		private function addHandler(e:Event):void
		{
			stage.addEventListener(Event.RESIZE, resizeHandler);
			_bg.addEventListener(MouseEvent.CLICK, clickHandler);
			
			_close.addEventListener(MouseEvent.ROLL_OVER, closeOver);
			_close.addEventListener(MouseEvent.ROLL_OUT, closeOut);
			_close.addEventListener(MouseEvent.CLICK, clickHandler);
			
			gotoAndPlay("start");
			_contentHolder.gotoAndPlay("start");
			
			stage.focus = null;
			resizeHandler(null);
			
		}
		private function closeOver(e:MouseEvent):void
		{
			_close.gotoAndPlay("over")
		}
		
		private function closeOut(e:MouseEvent):void
		{
			_close.gotoAndPlay("out")
		}
		private function resizeHandler(e:Event):void
		{
			_bg.width = stage.stageWidth;
			_bg.height = stage.stageHeight;
			_contentHolder.x = Math.round((stage.stageWidth - _contentHolder.width) / 2);
			_contentHolder.y = Math.round((stage.stageHeight - _contentHolder.height) / 2);
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			_bg.removeEventListener(MouseEvent.CLICK, clickHandler);
			_close.removeEventListener(MouseEvent.ROLL_OVER, closeOver);
			_close.removeEventListener(MouseEvent.ROLL_OUT, closeOut);
			_close.removeEventListener(MouseEvent.CLICK, clickHandler);
			gotoAndPlay("hide");
			_contentHolder.gotoAndPlay("hide");
		}
		
		private function remooveHandler(e:Event):void
		{
			stage.removeEventListener(Event.RESIZE, resizeHandler);
		}
		
		public function remoovePopup():void
		{
			parent.removeChild(this)
		}
	}
	
}