package elements.scroll
{
	import caurina.transitions.Tweener;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class  ScrollBar extends MovieClip
	{
		private var _maskScroll:MovieClip;
		public var content:MovieClip;
		private var _upButton:MovieClip;
		private var _downButton:MovieClip;
		
		private var _controllHolder:MovieClip
		
		private var _currentPos:Number = 0;
		private var _step:Number = 50;
		private var _bgContent:MovieClip;
		
		public function ScrollBar():void
		{
			content = getChildByName("contentClip") as MovieClip;
			_maskScroll = getChildByName("maskClip") as MovieClip;
			_controllHolder = getChildByName("controllHolder") as MovieClip;
			
			_bgContent = content.getChildByName("contentBG") as MovieClip;
			
			_upButton = _controllHolder.getChildByName("up") as MovieClip;
			_downButton = _controllHolder.getChildByName("down") as MovieClip;
			
			content.mask = _maskScroll;
			
			_upButton.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			_downButton.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			
			_upButton.addEventListener(MouseEvent.ROLL_OUT, outHandler);
			_downButton.addEventListener(MouseEvent.ROLL_OUT, outHandler);
			
			_upButton.addEventListener(MouseEvent.CLICK, upClickHandler);
			_downButton.addEventListener(MouseEvent.CLICK, downClickHandler);
			
			var upArea:MovieClip = _upButton.getChildByName("area") as MovieClip;
			var downArea:MovieClip = _downButton.getChildByName("area") as MovieClip;
			
			_upButton.mouseChildren = false;
			_downButton.mouseChildren = false;
			
			_upButton.hitArea = upArea;
			_downButton.hitArea = downArea;
			
			_upButton.buttonMode = true;
			_downButton.buttonMode = true;
			
			//stage.addEventListener(Event.RESIZE, resizeHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, remoovedHandler);
			
		}
		
		public function init(data:XML):void
		{
			WebSite.getContentFpomBlock(data.content, content);
			setKoord(data.@x, data.@y);
			setSize(data.@width, data.@height);
			
		}
		
		public function setSize(inWidth:Number, inHeight:Number):void
		{
			_maskScroll.width = inWidth;
			_maskScroll.height = inHeight;
			
			_bgContent.width = inWidth;
			_bgContent.height = content.height + 10;
			
			_controllHolder.x = inWidth + 10;
			_downButton.y = inHeight;
			
			if (content.height <= _maskScroll.height)
				_controllHolder.visible = false;
			else
			{
				_controllHolder.visible = true;
				addEventListener(MouseEvent.ROLL_OVER, areaOverHandler);
				addEventListener(MouseEvent.ROLL_OUT, areaOutHandler);
			}
			
		}
		
		public function setKoord(newX:Number, newY:Number):void
		{
			x = newX;
			y = newY;
		}
		
		private function areaOverHandler(e:MouseEvent):void
		{
			addEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
		}
		
		private function areaOutHandler(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
		}
		
		private function wheelHandler(e:MouseEvent):void
		{
			_currentPos = _currentPos + e.delta * _step;
			if (_currentPos > 0)
					_currentPos = 0;
			
			if (_currentPos < -(content.height - _maskScroll.height))
				_currentPos = -(content.height - _maskScroll.height);
				
			Tweener.addTween(content, { y:_currentPos, time:0.3 } );
		}
		
		private function overHandler(e:MouseEvent):void
		{
			e.target.gotoAndPlay("over")
		}
		private function outHandler(e:MouseEvent):void
		{
			e.target.gotoAndPlay("out")
		}
		private function upClickHandler(e:MouseEvent):void
		{
			if (_currentPos < 0)
			{
				_currentPos = _currentPos + _step;
				
				if (_currentPos > 0)
					_currentPos = 0;
				
				Tweener.addTween(content, { y:_currentPos, time:0.3 } );
			}
		}
		private function downClickHandler(e:MouseEvent):void
		{
			if (_currentPos > -(content.height - _maskScroll.height))
			{
				_currentPos = _currentPos - _step;
				
				if (_currentPos < -(content.height - _maskScroll.height))
					_currentPos = -(content.height - _maskScroll.height);
				
				Tweener.addTween(content, { y:_currentPos, time:0.3 } );
			}
		}
		
		private function remoovedHandler(e:Event):void
		{
			
		}
	}
	
}