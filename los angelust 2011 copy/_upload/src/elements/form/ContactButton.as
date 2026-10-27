package elements.form
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class  ContactButton extends MovieClip
	{
		private var _area:MovieClip;
		private var _text:TextField;
		private var _effect:MovieClip;
		
		public function ContactButton():void
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
			_text.htmlText = String(data.property.(@id == 1));
			
			_text.autoSize = TextFieldAutoSize.LEFT;
			
			if (String(data.property.(@id == 1).@embedFonts) == "true") 
				_text.embedFonts = true;
				
			_text.y = Math.round((_area.height - _text.textHeight) / 2);
			_text.x = 10;
			_effect.width = _text.textWidth + 22;
			_area.width = _text.textWidth + 22;
			
			setKoord(Number(data.@x), Number(data.@y));
		}
		public function setKoord(newX:Number, newY:Number):void
		{
			x = newX;
			y = newY;
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