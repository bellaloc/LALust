package elements.news
{
	import caurina.transitions.Tweener;
	import elements.scroll.ScrollBar;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class  AdvansedContent extends MovieClip
	{
		public var newsContent:Object = new Object;
		public var numberOfItems:uint;
		private var _elementsList:XMLList;
		
		public var _newsItems:Array = [];
		
		public var selectedItem:uint = 0;
		private var target:MovieClip;
		private var _container:MovieClip;
		
		private var _XML:XML;
		
		private var delayTmr:Timer = new Timer(300);
		
		public function AdvansedContent():void
		{
			target = MovieClip(MainDocument.getMainTimline().content);
		}
		public function init(data:XML):void
		{
			_XML = data;
			_elementsList = data.elements();
			numberOfItems = _elementsList.length();
			
			var koord:Number = 0;
			
			for (var i:uint = 0; i < numberOfItems; i++)
			{
				var newsItem:AdvansedContentItem = new AdvansedContentItem();
				newsItem.num = i;
				_newsItems[i] = newsItem;
				_newsItems[i].parentModule = returnParent(this);
				newsItem.init(XML(data.item.(@id == i)));
				addChild(_newsItems[i]);
			}
			for (i = 0; i < numberOfItems; i++)
			{
				_newsItems[i].y = koord;
				koord = koord + 20;
			}
			
			setKoord(data.@x, data.@y);
			
			delayTmr.start();
			delayTmr.addEventListener(TimerEvent.TIMER, setHandler);
			
		}
		
		private function setHandler(e:TimerEvent):void
		{
			_container = new MovieClip();
			_container.alpha = 0;
			_container.y = 100;
			Tweener.addTween(_container, { alpha:1, y:0, time:0.5, transition:"easeOutBack" } );
			target.addChild(_container);
			delayTmr.stop();
			delayTmr.removeEventListener(TimerEvent.TIMER, setHandler);
			setPart(_XML.item.(@id == selectedItem).content);
			MainDocument.getMainTimline().addEventListener("switchPage", switchPageHandler);
		}
		
		private function switchPageHandler(e:Event):void
		{
			MainDocument.getMainTimline().removeEventListener("switchPage", switchPageHandler);
			Tweener.addTween(_container, { alpha:0, y:100,time:0.3, onComplete:function() { 
			target.removeChild(_container); }} );
		}
		
		public function setPart(data:XMLList):void
		{
			WebSite.getContentFpomBlock(data, _container);
		}
		
		public function cheangePart():void
		{
			Tweener.addTween(_container, { alpha:0, y:100, time:0.3, onComplete:function() { 
				
				target.removeChild(_container);
				_container = new MovieClip();
				_container.alpha = 0;
				_container.y = 100;
				target.addChild(_container);
				setPart(_XML.item.(@id == selectedItem).content);
				Tweener.addTween(_container, { alpha:1, y:0, time:0.5, transition:"easeOutBack" } ) }} ); 
		}
		
		public function setKoord(newX:Number, newY:Number):void
		{
			x = newX;
			y = newY;
		}
		private function returnParent(target:*):AdvansedContent
		{
			return target as AdvansedContent;
		}
	}
	
}