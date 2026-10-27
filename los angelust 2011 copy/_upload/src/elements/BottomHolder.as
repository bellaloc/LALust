package elements
{
	import caurina.transitions.Tweener;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class  BottomHolder extends  MovieClip
	{
		private var _bg:MovieClip;
		
		public function BottomHolder():void
		{
			_bg = getChildByName("bg") as MovieClip;
			stage.addEventListener(Event.RESIZE, resizeHandler);
			MainDocument.getMainTimline().addEventListener("switchPage", switchPageHandler);
			buttonsHolder.alpha = 0;
			resizeHandler(null);
			
			this.alpha = 0;
			Tweener.addTween(this, { alpha:1, time:0.9 } );
		}
		private function resizeHandler(e:Event):void
		{
			_bg.width = stage.stageWidth;
			y = stage.stageHeight - 56;
		}
		
		private function switchPageHandler(e:Event):void
		{
			if (WebSite.getPageType(MainDocument.rootLink) == 2)
				Tweener.addTween(buttonsHolder, { alpha:1, time:0.8 } );
			else
				Tweener.addTween(buttonsHolder, { alpha:0, time:0.8 } );
		}
	}
	
}