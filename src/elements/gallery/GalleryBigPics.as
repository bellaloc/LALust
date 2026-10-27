package elements.gallery
{
	import adobe.utils.CustomActions;
	import caurina.transitions.Tweener;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class  GalleryBigPics extends MovieClip
	{
		private var _preloader:MovieClip;
		private var _persents:TextField;
		
		private var _currentScale:Number = 1;
		
		public var ellementFirst:GalleryElement;
		public var ellementNext:GalleryElement;
		
		public var currEll:GalleryElement;
		
		private var _timer:Timer = new Timer(8 * 1000);
		private var _next:MovieClip;
		private var _prev:MovieClip;
		
		public function GalleryBigPics():void
		{
			
			_preloader = getChildByName("preloaderClip") as MovieClip;
			_persents = getChildByName("preloadTxt") as TextField;
			stage.addEventListener(Event.RESIZE, resizeHandler);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			
			addEventListener("loaded", loadedHandler);
			addEventListener("unload", unloadHandler);
			
			_next = getChildByName("nextBT") as MovieClip;
			_prev = getChildByName("prevBT") as MovieClip;
			
			resizeHandler(null);
			
			MainDocument.getMainTimline().addEventListener("switchPage", switchPageHandler);
			this.visible = false;
		}
		
		private function switchPageHandler(e:Event):void
		{
			if (WebSite.getPageType(MainDocument.rootLink) == 2 && WebSite.getPageType(MainDocument.previosLink) == 1)
			{
				this.visible = true;
				Tweener.addTween(this, { alpha:1, time:0.9 } );
			}
			if (WebSite.getPageType(MainDocument.rootLink) == 1 && WebSite.getPageType(MainDocument.previosLink) == 2)
			{
				Tweener.addTween(this, { alpha:0, time:0.8 , onComplete:function() { 
					
					this.visible = false; 
					if (ellementFirst)
					{
						Bitmap(ellementFirst.loaderCont.contentLoaderInfo.content).bitmapData = new BitmapData(ellementFirst.loaderCont.contentLoaderInfo.width, 
						ellementFirst.loaderCont.contentLoaderInfo.height,true, 0x00000000);
					}
					if (ellementNext)
					{
						Bitmap(ellementNext.loaderCont.contentLoaderInfo.content).bitmapData = new BitmapData(ellementNext.loaderCont.contentLoaderInfo.width, 
						ellementNext.loaderCont.contentLoaderInfo.height,true, 0x00000000);
					}
				}} );
				
			}
		}
		
		
		public function setDelay(num:uint):void
		{
			_timer.delay = Number(num * 1000);
		}
		
		public function init(nameSt:String):void
		{
			if (ellementFirst)
			{
				next(nameSt);
			}
			else
			{
				ellementFirst = new GalleryElement(nameSt);
				addChild(ellementFirst);
				ellementFirst.name = "firstEll";
				setChildIndex(ellementFirst, 1);
			}
		}
		
		public function next(nameSt:String):void
		{
			if(!ellementNext){
				if (ellementFirst.loaded)
				{
					if (ellementFirst.showed)
					{
						ellementNext = new GalleryElement(nameSt);
						addChild(ellementNext);
						ellementNext.name = "nextEll";
						setChildIndex(ellementNext, 2);
						setChildIndex(_preloader, 3)
						setChildIndex(_persents, 4)
					}
					else
					{
						Tweener.addTween(ellementFirst, { alpha:0, time:0.2,
						onComplete:function() { 
							try{
								ellementFirst.loaderCont.close()
								ellementFirst.loaderCont.unload();
							}
							catch(e:Error){
								ellementFirst.loaderCont.unload();
							}
							removeChild(ellementFirst);
							ellementFirst = new GalleryElement(nameSt);
							ellementFirst.alpha = 1;
							addChild(ellementFirst);
							setChildIndex(ellementFirst, 1);
						}} );
					}
				}
				else 
				{
					try{
						ellementFirst.loaderCont.close()
						ellementFirst.loaderCont.unload();
					}
					catch(e:Error){
						ellementFirst.loaderCont.unload();
					}
					ellementFirst.loaderCont.load(new URLRequest(nameSt));
				}
			}
			else {
				
				if (ellementNext.loaded)
				{
					if (ellementNext.showed)
					{
						
						ellementFirst.conentHolder.scaleX = _currentScale;
						ellementFirst.conentHolder.scaleY = _currentScale;
						
						ellementFirst.conentHolder.x = ellementNext.conentHolder.x;
						ellementFirst.conentHolder.y = ellementNext.conentHolder.y;
						
						Bitmap(ellementFirst.loaderCont.contentLoaderInfo.content).bitmapData = Bitmap(ellementNext.loaderCont.contentLoaderInfo.content).bitmapData;
						Bitmap(ellementFirst.loaderCont.contentLoaderInfo.content).smoothing = true;
						
						ellementFirst._conent.scaleX = ellementNext._conent.scaleX;
						ellementFirst._conent.scaleY = ellementNext._conent.scaleY;
						
						try{
							ellementNext.loaderCont.close()
							ellementNext.loaderCont.unload();
						}
						catch(e:Error){
							ellementNext.loaderCont.unload();
						}
						removeChild(ellementNext);
						ellementNext = new GalleryElement(nameSt);
						addChild(ellementNext);
						setChildIndex(ellementNext, 2);
					}
					else
					{
						Tweener.addTween(ellementNext, { alpha:0, time:0.2,
						onComplete:function() { 
							try{
								ellementNext.loaderCont.close()
								ellementNext.loaderCont.unload();
							}
							catch(e:Error){
								ellementNext.loaderCont.unload();
							}
							removeChild(ellementNext);
							ellementNext = new GalleryElement(nameSt);
							ellementNext.alpha = 1;
							addChild(ellementNext);
							setChildIndex(ellementNext, 2);
						}} );
					}
				}
				else 
				{
					try{
						ellementNext.loaderCont.close()
						ellementNext.loaderCont.unload();
					}
					catch(e:Error){
						ellementNext.loaderCont.unload();
					}
					removeChild(ellementNext);
					ellementNext = new GalleryElement(nameSt);
					addChild(ellementNext);
					setChildIndex(ellementNext, 2);
				}
			}
			_currentScale = 1;
			
			_persents.htmlText = "";
			Tweener.addTween(_preloader, { alpha:1, time:0.5 } );
			Tweener.addTween(_persents, { alpha:1, time:0.5 } );
		}
		
		private function resizeHandler(e:Event):void
		{
			_preloader.x = Math.round((stage.stageWidth - _preloader.width) / 2);
			_preloader.y = Math.round((stage.stageHeight - _preloader.height) / 2);
			
			_persents.x = _preloader.x;
			_persents.y = _preloader.y + 30;
			_persents.x = _preloader.x + 18;
			
			_next.x = stage.stageWidth - 18;
		}
		
		private function forZoomResizeHandler(e:Event):void
		{
			currEll.conentHolder.scaleX = 1;
			currEll.conentHolder.scaleY = 1;
				
			currEll.conentHolder.x = 0;
			currEll.conentHolder.y = 0;
				
			_currentScale = 1;
				
			if (currEll.loaderCont.contentLoaderInfo.width *0.9> stage.stageWidth && 
				currEll.loaderCont.contentLoaderInfo.height *0.9> stage.stageHeight)
			{
				dispatchEvent(new Event("ZoomIn"));
			}
			else
				dispatchEvent(new Event("noZoomIn"));
				
			dispatchEvent(new Event("noZoomOut"));
		}
		
		private function loadedHandler(e:Event):void
		{
			currEll = GalleryElement(e.target);
			e.stopPropagation();
			
			addEventListener("zoomIn", zoomInHandler);
			addEventListener("zoomOut", zoomOutHandler);
			
			
			currEll.loaderInfo.addEventListener(Event.INIT, addEventsHAndler);
			currEll.addEventListener(MouseEvent.MOUSE_DOWN, startDragHandler);
			currEll.addEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
			
			stage.addEventListener(Event.RESIZE, forZoomResizeHandler);
			
			if (currEll.loaderCont.contentLoaderInfo.width *0.9> stage.stageWidth && 
				currEll.loaderCont.contentLoaderInfo.height * 0.9 > stage.stageHeight)
			{
				dispatchEvent(new Event("ZoomIn"));
			}
			else
				dispatchEvent(new Event("noZoomIn"));
			dispatchEvent(new Event("noZoomOut"));
			
			_timer.start();
			
			currEll.conentHolder.buttonMode = true;
			
		}
		private function addEventsHAndler(E:Event):void
		{
			trace("initt")
		}
		
		
		private function unloadHandler(e:Event):void
		{
			currEll = GalleryElement(e.target);
			 
			currEll.removeEventListener(MouseEvent.MOUSE_DOWN, startDragHandler);
			currEll.removeEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
			
			e.stopPropagation();
			
			removeEventListener("zoomIn", zoomInHandler);
			removeEventListener("zoomOut", zoomOutHandler);
			stage.removeEventListener(Event.RESIZE, forZoomResizeHandler);
			
			dispatchEvent(new Event("noZoomIn"));
			dispatchEvent(new Event("noZoomOut"));
			
			currEll.conentHolder.buttonMode = false;
			
			_timer.reset();
			
			currEll.conentHolder.buttonMode = true;
		}
		
		private function timerHandler(e:TimerEvent):void
		{
			dispatchEvent(new Event("slideNextPic"));
		}
		
		private function zoomInHandler(e:Event):void
		{
			//if (currEll.conentHolder.width * _currentScale < currEll.loaderCont.contentLoaderInfo.width)
			if (currEll.conentHolder.width * _currentScale < currEll.loaderCont.contentLoaderInfo.width)
			{
				dispatchEvent(new Event("ZoomOut"));
				_currentScale = _currentScale + 0.1;
				Tweener.addTween(currEll.conentHolder, { scaleX:_currentScale, scaleY:_currentScale, time:0.4 } );
			}
			else
				dispatchEvent(new Event("noZoomIn"));
		}
		private function zoomOutHandler(e:Event):void
		{
			//if (_currentScale >1)
			if (_currentScale >1)
			{
				dispatchEvent(new Event("ZoomIn"));
				_currentScale = _currentScale - 0.1;
				Tweener.addTween(currEll.conentHolder, { scaleX:_currentScale, scaleY:_currentScale, time:0.4 } );
				
			}
			else
				dispatchEvent(new Event("noZoomOut"));
		}
		
		private function startDragHandler(e:MouseEvent):void
		{
			var rect:Rectangle = new Rectangle(0, 0, -(currEll.conentHolder.scaleX*(currEll.loaderCont.contentLoaderInfo.width * currEll.skalingKoeff) - stage.stageWidth),
				-(currEll.conentHolder.scaleY*(currEll.loaderCont.contentLoaderInfo.height * currEll.skalingKoeff) - stage.stageHeight));
				
			currEll.conentHolder.startDrag(false, rect);
			stage.addEventListener(Event.MOUSE_LEAVE, leaveHandler);
			
		}
		
		private function stopDragHandler(e:MouseEvent):void
		{
			currEll.conentHolder.stopDrag();
			stage.removeEventListener(Event.MOUSE_LEAVE, leaveHandler);
		}
		
		private function leaveHandler(e:Event):void
		{
			currEll.conentHolder.stopDrag();
			stage.removeEventListener(Event.MOUSE_LEAVE, leaveHandler);
		}
		
	}
	
}