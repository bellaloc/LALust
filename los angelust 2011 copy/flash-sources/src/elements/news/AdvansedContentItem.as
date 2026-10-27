package elements.news
{
	import elements.ContentImage;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class  AdvansedContentItem extends MovieClip
	{
		private var _nameText:TextField;
		private var _area:MovieClip;
		
		private var _XML:XML;
		public var size:Number;
		
		public var num:uint
		public var parentModule:AdvansedContent;
		
		public function AdvansedContentItem():void
		{
			_nameText = holder.getChildByName("tf") as TextField;
			_area = getChildByName("areaMC") as MovieClip;
			
			_nameText.autoSize = TextFieldAutoSize.LEFT;
			_nameText.multiline = true;
			
			addEventListener(MouseEvent.ROLL_OVER, overHandler);
			addEventListener(MouseEvent.ROLL_OUT, outHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		public function init(data:XML):void
		{
			_XML = data;
			
			_nameText.htmlText = String(_XML.property.(@id == 1));
			
			if (String(_XML.property.(@id == 1).@embedFonts) == "true")
				_nameText.embedFonts = true;
				
			
			if (parentModule.selectedItem == num)
				selectItem();
			
		}
		
		private function overHandler(e:MouseEvent):void
		{
			if (parentModule.selectedItem != num)
			{
				gotoAndPlay("over")
			}
		}
		
		private function outHandler(e:MouseEvent):void
		{
			if (parentModule.selectedItem != num)
			{
				gotoAndPlay("out")
			}
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			if (parentModule.selectedItem != num)
			{
				parentModule._newsItems[parentModule.selectedItem].gotoAndPlay("out");
				parentModule.selectedItem = num;
				parentModule.cheangePart();
			}
		}
		
		public function selectItem():void 
		{
			gotoAndPlay("over");
		}

	}
	
}