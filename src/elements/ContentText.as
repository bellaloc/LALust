package elements
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class  ContentText extends Sprite
	{ 
		private var _text:TextField;
		
		public function ContentText():void
		{
			_text = getChildByName("tf") as TextField;
		}
		public function init(data:XML):void
		{
			_text.width = data.@width;
			_text.height = data.@height;
			
			setKoord(Number(data.@x), Number(data.@y));
			
			_text.htmlText = String(data);
			//_text.autoSize = TextFieldAutoSize.LEFT;
			
			if (String(data.@embedFonts) == "true") 
				_text.embedFonts = Boolean(data.@embedFonts);
			
			if (String(data.@selectable) == "true") 
				_text.selectable = Boolean(data.@selectable);
			
		}
		public function setKoord(newX:Number, newY:Number):void
		{
			x = newX;
			y = newY;
		}
	}
	
}