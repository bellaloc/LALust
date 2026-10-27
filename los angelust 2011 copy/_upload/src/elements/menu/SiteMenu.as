package elements.menu
{
	import adobe.utils.CustomActions;
	import flash.display.MovieClip;
	import flash.events.Event;
	import MainDocument;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class SiteMenu extends MovieClip
	{
		private var _elementsList:XMLList;
		private var _numberOfItems:uint;
		
		public var target:MovieClip
		public var selectedItem:SiteMenuItem;
		public var overedItem:SiteMenuItem;
		
		public var submenus:Array = [];
		
		public function SiteMenu():void
		{
			target = this;
		}
		
		public function init(dataObject:XML):void
		{
			_elementsList = dataObject.data.elements();
			_numberOfItems = _elementsList.length();
			
			setKoord(Number(dataObject.@x), Number(dataObject.@y));
			
			var i:uint = 1;
			var xmlObj:XML;
			
			for each(xmlObj in dataObject.data.children()) 
			{
				this["item" + i] = new SiteMenuItem();
				this["item" + i].y = 31 * (i - 1);
				target.addChild(this["item" + i]);
				
				this["item" + i].tabEnabled = false;
				this["item" + i].parentMenu = this;
				this["item" + i].init(xmlObj);
				this["item" + i].start();
				
				i++;
			}
			
		}
		
		public function showSubMenu(data:XML, num:uint, newX:Number, newY:Number):void
		{
			submenus[num] = new SiteSubMenu();
			submenus[num].x = newX;
			submenus[num].y = newY;
			
			target.addChild(submenus[num]);
			target.setChildIndex(submenus[num], 0);
			
			submenus[num].init(data);
			submenus[num].parentMenuItem = num;
			submenus[num].opening = true;
			
		}
		
		public function hideSubMenu(num:uint):void
		{
			submenus[num].readyTooHide();
		}
		
		public function setKoord(newX:Number, newY:Number):void
		{
			x = newX;
			y = newY;
		}
		
		private function getMenuItemForIndex(num:uint):SiteMenuItem
		{
			return this["item" + (num)] as SiteMenuItem;
		}
		
		public function getAsMenuItem(target:*):SiteMenuItem
		{
			return target as SiteMenuItem
		}
		
	}
	
}