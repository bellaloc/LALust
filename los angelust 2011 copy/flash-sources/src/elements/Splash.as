package elements
{
	import adobe.utils.CustomActions;
	import elements.gallery.GalleryButton;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class  Splash extends MovieClip
	{
		private var _tf1:TextField;
		private var _tf2:TextField;
		private var _tf3:TextField;
		private var _tf4:TextField;
		
		private var _normMode:GalleryButton;
		private var _fsMode:GalleryButton
		
		private var _holder:MovieClip
		
		private var _bg:MovieClip
		
		public function Splash():void
		{
			_bg = bg;
			
			_holder = getChildByName("holder4") as MovieClip;
			
			_normMode = getChildByName("btn1") as GalleryButton;
			_fsMode = getChildByName("btn2") as GalleryButton;
			
			for (var i:uint = 1; i < 5; i++ )
			{
				this["_tf" + i] = this["holder" + i].getChildByName("tf") as TextField;
				this["_tf" + i].autoSize = TextFieldAutoSize.LEFT;
				MainDocument.getMainTimline().getGloballText(i - 1, this["_tf" + i]);
				this["_tf" + i].x = Math.round((_bg.width - this["_tf" + i].textWidth) / 2);
			}
			
			_normMode.setNum(7);
			_fsMode.setNum(8);
			
			_normMode.addEventListener(MouseEvent.CLICK, normClickHandler);
			_fsMode.addEventListener(MouseEvent.CLICK, fsClickHandler);
			
			stage.addEventListener(Event.RESIZE, resizehandler);
			resizehandler(null);
		}
		
		private function playSite():void
		{
			stage.removeEventListener(Event.RESIZE, resizehandler);
			_normMode.addEventListener(MouseEvent.CLICK, normClickHandler);
			_fsMode.addEventListener(MouseEvent.CLICK, fsClickHandler);
			gotoAndPlay("hide");
			MainDocument.getMainTimline().gotoAndPlay("site");
		}
		
		private function resizehandler(e:Event):void
		{
			this.x = Math.round((stage.stageWidth - _bg.width) / 2);
			this.y = Math.round((stage.stageHeight - _bg.height) / 2);
			
			_tf4.y = Math.round(stage.stageHeight / 2) - 30;
		}
		
		private function normClickHandler(e:MouseEvent):void
		{
			stage["displayState"] = "normal";
			playSite();
		}
		private function fsClickHandler(e:MouseEvent):void
		{
			stage["displayState"] = "fullScreen";
			playSite();
		}
	}
	
}