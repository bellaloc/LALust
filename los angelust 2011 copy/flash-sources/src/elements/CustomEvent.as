package elements
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class  CustomEvent extends Event
	{
		public var customNumber:uint;
		
		public function CustomEvent(type:String, num:uint, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			super(type);
			customNumber = num;
		}

	}
	
}