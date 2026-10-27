package elements
{
	import adobe.utils.CustomActions;
	import caurina.transitions.Tweener;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import MainDocument;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class GradientText extends MovieClip
	{
		private var _mask:MovieClip;
		private var _conent:MovieClip;
		private var _gradient:MovieClip;
		
		public function GradientText():void
		{
			_mask = getChildByName("tfMask") as MovieClip;
			_conent = getChildByName("tfContent") as MovieClip;
			_gradient = getChildByName("gradient") as MovieClip;
			
			_gradient.mask = _mask;
		}
		
		public function init(data:XML):void
		{
			TextField(_mask.tf).htmlText = String(data.property.(@id == 1));
			TextField(_mask.tf).autoSize = TextFieldAutoSize.LEFT;
			
			TextField(_conent.tf).htmlText = String(data.property.(@id == 1));
			TextField(_conent.tf).autoSize = TextFieldAutoSize.LEFT;
			
			if (String(data.property.(@id == 1).@embedFonts) == "true") 
			{
				TextField(_mask.tf).embedFonts = true;
				TextField(_conent.tf).embedFonts = true;
			}
			
			setKoord(Number(data.@x), Number(data.@y));
			setSize(Number(data.@width), Number(data.@height));
		}
		
		public function setSize(inWidth:Number, inHeight:Number):void
		{
			_gradient.width = inWidth;
			_gradient.height = inHeight;
		}
		
		public function setKoord(newX:Number, newY:Number):void
		{
			x = newX;
			y = newY;
		}
	}
	
}