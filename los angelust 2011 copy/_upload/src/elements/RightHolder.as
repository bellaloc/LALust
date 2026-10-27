package elements
{
	import caurina.transitions.Tweener;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class  RightHolder extends  MovieClip
	{
		
		public function RightHolder():void
		{
			stage.addEventListener(Event.RESIZE, resizeHandler);
			this.alpha = 0;
			Tweener.addTween(this, { alpha:1, time:0.9 } );
			resizeHandler(null);
		}
		private function resizeHandler(e:Event):void
		{
			x = stage.stageWidth - 101;
		}
	}
	
}