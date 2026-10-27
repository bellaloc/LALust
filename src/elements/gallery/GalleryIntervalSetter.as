package elements.gallery
{
	import elements.CustomEvent;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class  GalleryIntervalSetter extends MovieClip
	{
		private var _tf:TextField;
		private var _dragMC:MovieClip;
		private var _maskMC:MovieClip;
		private var _dragHolder:MovieClip;
		
		private var _hight:MovieClip;
		private var _low:MovieClip;
		
		public var interval:uint;
		
		public function GalleryIntervalSetter():void
		{
			_tf = getChildByName("tf") as TextField;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			
			_dragHolder = getChildByName("dragHolder") as MovieClip;
			_dragMC = _dragHolder.getChildByName("dragg") as MovieClip;
			_maskMC = _dragHolder.getChildByName("maskDrag") as MovieClip;
			
			_dragMC.addEventListener(MouseEvent.MOUSE_DOWN, startDragEvent);
			_dragMC.addEventListener(MouseEvent.MOUSE_UP, stopDragEvent);
			
			_dragMC.x = 48;
			interval = 8;
			
			_hight = _dragHolder.getChildByName("hight") as MovieClip;
			_low = _dragHolder.getChildByName("low") as MovieClip;
			
			_hight.addEventListener(MouseEvent.CLICK, highHandler);
			_low.addEventListener(MouseEvent.CLICK, lowHandler);
			
			_hight.buttonMode = true;
			_low.buttonMode = true;
			_dragMC.buttonMode = true;
			
		}
		public function init(data:XML):void
		{
			_tf.text = String(data.property.(@id == 1));
			
			if(String(data.property.(@id == 1).@embedFonts)=="true")
				_tf.embedFonts = true;
				
			setKoord(Number(data.@x), Number(data.@y));
			
			_dragHolder.x = _tf.textWidth + 30;
			_dragHolder.y = Math.ceil((_tf.textHeight - _dragHolder.height) / 2);
		}
		
		public function setKoord(newX:Number, newY:Number):void
		{
			x = newX;
			y = newY;
		}
		
		private function lowHandler(e:MouseEvent):void
		{
			interval--;
			if (interval < 1)
				interval = 16;
				
			_dragMC.x = interval * 6;
			
			if (_dragMC.x > _maskMC.width)
				_dragMC.x = _maskMC.width;
		}
		
		private function highHandler(e:MouseEvent):void
		{
			interval++;
			if (interval > 16)
				interval = 1;
				
			_dragMC.x = interval * 6;
			
			if (_dragMC.x > _maskMC.width)
				_dragMC.x = _maskMC.width;
		}
		
		private function  startDragEvent(e:MouseEvent):void
		{
			_dragMC.startDrag(true, new Rectangle(6, 0, _maskMC.width-6, 0));
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragEvent);
		}
		
		private function stopDragEvent(e:MouseEvent):void
		{
			_dragMC.stopDrag();
			
			interval = Math.ceil(_dragMC.x / 6);
			_dragMC.x = interval * 6;
			
			if (_dragMC.x > _maskMC.width)
				_dragMC.x = _maskMC.width;
			
			parent.dispatchEvent(new CustomEvent("newInterval",interval));
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragEvent);
		}
	}
	
}