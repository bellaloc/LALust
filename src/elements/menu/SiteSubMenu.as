package elements.menu
{
	import adobe.utils.CustomActions;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.*;
	import MainDocument;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class SiteSubMenu extends MovieClip
	{
		private var _elementsList:XMLList;
		private var _numberOfItems:uint;
		private var _closeTimer:Timer = new Timer(300);
		
		private var target:MovieClip
		private var _bg:MovieClip;
		private var closing:Boolean = false;
		public var selectedItem:SiteSubMenuItem;
		public var overedItem:SiteSubMenuItem;
		public var sizeArr:Array = [];
		public var parentMenuItem:uint;
		public var parentMenu:SiteMenu;
		
		public var opening:Boolean = false;
		
		public function SiteSubMenu():void
		{
			target = MovieClip(mc);
			_bg = target.getChildByName("bg") as MovieClip;
		}
		
		public function init(dataObject:XML):void
		{
			_elementsList = dataObject.elements();
			_numberOfItems = _elementsList.length();
			
			var i:uint = 1;
			var xmlObj:XML;
			
			for each(xmlObj in dataObject.children()) 
			{
				this["item" + i] = new SiteSubMenuItem();
				target.addChild(this["item" + i]);
				
				this["item" + i].tabEnabled = false;
				this["item" + i].parentMenu = this;
				this["item" + i].init(xmlObj);
				i++;
			}
			
			var koord:Number = 0;
			
			for (i = 0; i < sizeArr.length; i++ )
			{
				koord = koord - (Number(sizeArr[i]));
				this["item" + (i + 1)].x = koord;
				this["item" + (i + 1)].start();
			}
		}
		// closing
		public function close():void
		{
			closing = true;
			gotoAndPlay("close");
			_closeTimer.stop();
			_closeTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
			removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
		}
		public function remoove():void
		{
			parent.removeChild(this)
			opening = false;
		}
		
		public function readyTooHide():void
		{
			if (!closing)
			{
				_closeTimer.start();
				_closeTimer.addEventListener(TimerEvent.TIMER, timerHandler);
				addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
				addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			}
		}
		
		private function timerHandler(e:TimerEvent):void
		{
			_closeTimer.stop();
			_closeTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
			removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			close();
		}
		
		private function rollOverHandler(e:MouseEvent):void
		{
			_closeTimer.stop();
			_closeTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		private function rollOutHandler(e:MouseEvent):void
		{
			_closeTimer.stop();
			_closeTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
			removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			close();
		}
		//--------------
		private function getMenuItemForIndex(num:uint):SiteSubMenuItem
		{
			return this["item" + (num)] as SiteSubMenuItem;
		}
		
		public function getAsMenuItem(target:*):SiteSubMenuItem
		{
			return target as SiteSubMenuItem
		}
	}
	
}