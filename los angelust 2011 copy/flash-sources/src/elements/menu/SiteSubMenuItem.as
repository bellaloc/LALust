package elements.menu
{
	import adobe.utils.CustomActions;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import MainDocument;
	
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class  SiteSubMenuItem extends MovieClip
	{
		private var _text:TextField;
		private var _textHolder:MovieClip;
		private var _area:MovieClip;
		private var _effect:MovieClip;
		private var _num:uint;
		
		public var parentMenu:SiteSubMenu;
		public var hasSubMenu:Boolean = false;
		public var subMenuData:XML;
		
		public function SiteSubMenuItem():void
		{
			_area = getChildByName("areaClip") as MovieClip;
			_textHolder = getChildByName("holder") as MovieClip;
			_text = _textHolder.getChildByName("tf") as TextField;
			_effect = effectClip.getChildByName("bg") as MovieClip;
			
			addEventListener(MouseEvent.ROLL_OVER, overHandler);
			addEventListener(MouseEvent.ROLL_OUT, outHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
			MainDocument.getMainTimline().addEventListener("switchPage", switchPageHandler);
			
			mouseChildren = false;
			hitArea = _area;
			buttonMode = true;
			//addEventListener(Event.ADDED_TO_STAGE, addHandler);
		}
		
		public function init(data:XML):void
		{
			_num = uint(data.@pageId);
			
			if (data.hasOwnProperty("data"))
			{
				hasSubMenu = true;
				subMenuData = XML(data.data);
			}
			_text.autoSize = TextFieldAutoSize.LEFT;
			_text.htmlText = String(data.property.(@id == 1));
			
			if (String(data.property.(@id == 1).@embedFonts) == "true") 
				_text.embedFonts = true;
				
			_text.y = Math.round((_area.height - _text.textHeight) / 2);
			_text.x = 10;
			_effect.width = _text.textWidth + 20;
			_area.width = _text.textWidth + 21;
			
			parentMenu.sizeArr.push(_area.width);
		}
		
		private function overHandler(e:MouseEvent):void
		{
			if (MainDocument.rootLink != _num)
				over();
		}
		
		private function outHandler(e:MouseEvent):void
		{
			if (MainDocument.rootLink != _num)
				out();
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			if (MainDocument.rootLink != _num)
			{
				MainDocument.previosLink = MainDocument.rootLink;
				MainDocument.rootLink = _num;
				
				parentMenu.selectedItem = parentMenu.getAsMenuItem(this);
				
				dispatchEvent(new Event("switchPage", true, true));
			}
		}
		
		public function over():void
		{
			gotoAndPlay("over");
			parentMenu.overedItem = parentMenu.getAsMenuItem(this);
		}
		
		public function out():void
		{
			gotoAndPlay("out");
			parentMenu.overedItem = null;
		}
		
		public function start():void
		{
			gotoAndPlay("start");
			
			if (MainDocument.rootLink == _num)
			{
				over();
				parentMenu.selectedItem = parentMenu.getAsMenuItem(this);
			}
		}
		
		private function switchPageHandler(e:Event):void
		{
			if (_num == MainDocument.previosLink)
				out();
		}
	}
	
}