package 
{
	import elements.ContentImage;
	import elements.popup.SitePopup;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.events.TextEvent;
	import flash.utils.*;
	/**
	 * ...
	 * @author Funkey
	 * 
	 */
	public class  WebSite extends MovieClip
	{
		public function WebSite():void
		{
			addEventListener(TextEvent.LINK, linkHandler);
			addEventListener("switchPage",switchPageHandler)
		}
		public static function createPopup(dataXML:XML):void
		{
			var popup:SitePopup = new SitePopup();
			MainDocument.getMainTimline().addChild(popup);
			popup.DataInit(dataXML);
			
		}
		public static function getContentFpomBlock(blockData:XMLList, target:MovieClip):void
		{
		// untyped classis
		
			var item:XML;
			for each(item in blockData.children()) 
			{
				var variableName = String(item.@name);
				
				var newObject:Object = getDefinitionByName(variableName) as Class;
				var contentElement = new newObject();
				
				target.addChild(contentElement);
				contentElement.init(item);
			}
		//------------
		}
		
		public static function getPageType(id:uint):uint
		{
			return uint(MainDocument.getData().page.(@id == id).@type);
		}
		
		public static function remooveContentFpomTarget(target:MovieClip):void
		{
		// untyped classis
		
			var count:uint = target.numChildren;
			
			for (var i:uint = (count - 1); i <= 0; i-- )
			{
				target.removeChildAt(i);
				trace(target.numChildren)
			}
		//------------
		}
		
		public function getPageText(pageId:uint, textId:uint, txt:TextField):void
		{
			txt.htmlText = MainDocument.getData().page.(@id == pageId).text.(@id == textId);
		}
		public function getPagePic(pageId:uint, picId:uint, targ:ContentImage):void
		{
			targ.init(MainDocument.getData().page.(@id == pageId).pic.(@id == picId));
			targ.setSize(MainDocument.getData().page.(@id == pageId).pic.(@id == picId).@width,
						MainDocument.getData().page.(@id == pageId).pic.(@id == picId).@height);
		}
		public function getGloballText(textId:uint, txt:TextField):void
		{
			txt.htmlText = MainDocument.getData().text.(@id == textId);
		}
		
		private function linkHandler(e:TextEvent):void
		{
			var string:String = String(e.text);
			var arrArg:Array = string.split(",");
			
			if (arrArg[0] == "openPopup")
			{
				var dataXML:XML = XML(MainDocument.getData().popup.(@id == uint(arrArg[1])));
					
				createPopup(dataXML);
			}
			
			if (arrArg[0] == "page")
			{
				MainDocument.previosLink = MainDocument.rootLink;
				MainDocument.rootLink = uint(arrArg[1]);
				dispatchEvent(new Event("switchPage", true, true));
			}
			
			if (arrArg[0] == "fullScreen")
			{
				if (String(arrArg[1]) == "normal")
				{
					stage["displayState"] = "normal";
				}
				
				if (String(arrArg[1]) == "fullScreen")
				{
					stage["displayState"] = "fullScreen";
				}
				
				if (String(arrArg[1]) == "switch")
				{
					if (stage["displayState"] == "normal")
						stage["displayState"] = "fullScreen";
					
					else
						stage["displayState"] = "normal";
				}
			}
		}
		
		private function switchPageHandler(e:Event):void
		{
			if (MainDocument.previosLink == 0)
			{
				gotoAndPlay("show")
			}
		}
	}
	
}