package elements.gallery
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class  GalleryButton extends MovieClip
	{
		private var _limit = true;
		private var _area:MovieClip;
		private var _effect:MovieClip;
		private var _loadPic:Loader = new Loader();
		private var _tf:TextField;
		
		public function GalleryButton():void
		{
			addEventListener(MouseEvent.ROLL_OVER, overHandler);
			addEventListener(MouseEvent.ROLL_OUT, outHandler);
			
			_effect = eff.getChildByName("bg") as MovieClip;
			_tf = txt.getChildByName("tf") as TextField;
			_area = getChildByName("areaClip") as MovieClip;
			
			this.mouseChildren = false;
			this.buttonMode = true;
			this.hitArea = _area;
			
			_tf.autoSize = TextFieldAutoSize.LEFT;
		}
		public function init(data:XML):void
		{
			_tf.text = String(data.property.(@id == 1));
			
			if(String(data.property.(@id == 1).@embedFonts)=="true")
				_tf.embedFonts = true;
			
			if (data.elements().length() > 1)
			{
				_loadPic.load(new URLRequest(data.property.(@id == 2)));
				picHolder.addChild(_loadPic);
				
				_area.width = _tf.textWidth + 27;
				_effect.width = _area.width;
			}
			else 
			{
				_tf.x = -17;
				_area.width = _tf.textWidth + 8;
				_effect.width = _area.width;
			}
			
			setKoord(Number(data.@x), Number(data.@y));
		}
		
		public function setKoord(newX:Number, newY:Number):void
		{
			x = newX;
			y = newY;
		}
		
		private function overHandler(e:MouseEvent):void
		{
			if(_limit)
				gotoAndPlay("over");
		}
		private function outHandler(e:MouseEvent):void
		{
			if(_limit)
				gotoAndPlay("out");
		}
		public function setFlag(flag:Boolean):void
		{
			_limit = flag;
		}
	}
	
}