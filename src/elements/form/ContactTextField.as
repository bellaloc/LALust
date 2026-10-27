package elements.form
{
	import flash.events.FocusEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class ContactTextField extends TextField 
	{
		private var _lable:String
		public var _target:TextField
		
		public function ContactTextField(targ:TextField):void
		{
			_target = targ;
			
			_target.addEventListener(FocusEvent.FOCUS_IN, inFocus);
			_target.addEventListener(FocusEvent.FOCUS_OUT, outFocus);
		}
		
		public function setLable(lable:String):void
		{
			_lable = lable;
			_target.htmlText = lable;
		}
		
		private function inFocus(e:FocusEvent):void
		{
			if (_target.htmlText == _lable)
				_target.htmlText = "";
		}
		
		private function outFocus(e:FocusEvent):void
		{
			if (_target.htmlText == "")
				_target.htmlText = _lable;
		}
	}
	
}