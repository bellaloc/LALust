package elements
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class  GradientButton extends MovieClip
	{
		private var _area:MovieClip;
		private var _text:TextField;
		private var _effect:MovieClip;
		
		private var _data:XML;
		
		public function GradientButton():void
		{
			this.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, outHandler);
			
			_area = getChildByName("areaClip") as MovieClip;
			_text = holder.getChildByName("tf") as TextField;
			_effect = effectClip.getChildByName("bg") as MovieClip;
			
			this.mouseChildren = false;
			this.buttonMode = true;
			this.hitArea = _area;
		}
		public function init(data:XML):void
		{
			_data = data;
			_text.htmlText = String(data.property.(@id == 1));
			
			_text.autoSize = TextFieldAutoSize.LEFT;
			
			if (String(data.property.(@id == 1).@embedFonts) == "true") 
				_text.embedFonts = true;
				
			_text.y = Math.round((_area.height - _text.textHeight) / 2);
			_text.x = 10;
			_effect.width = _text.textWidth + 22;
			_area.width = _text.textWidth + 22;
			
			setKoord(Number(data.@x), Number(data.@y));
			
			if (String(data.@click) != "")
			{
				addEventListener(MouseEvent.CLICK, clickHandler);
			}
		}
		
		public function setKoord(newX:Number, newY:Number):void
		{
			x = newX;
			y = newY;
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			var string:String = String(_data.@click);
			var arrArg:Array = string.split(",");
			
			if (arrArg[0] == "openPopup")
			{
				var dataXML:XML = XML(MainDocument.getData().popup.(@id == uint(arrArg[1])));
					
				WebSite.createPopup(dataXML);
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
		
		private function overHandler(e:MouseEvent):void
		{
			e.target.gotoAndPlay("over");
		}
		
		private function outHandler(e:MouseEvent):void
		{
			e.target.gotoAndPlay("out");
		}
	}
	
}