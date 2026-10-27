package elements.gallery
{
	import adobe.utils.CustomActions;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts
	import elements.CustomEvent;
	import flash.filters.ColorMatrixFilter
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.net.NetConnection;
	import flash.net.URLRequest;
	import flash.net.*
	import flash.text.TextField;
	import MainDocument;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class SiteGallery extends MovieClip
	{
		public var curentPic:uint = 0;
		
		private var _numberOfPics:uint;
		
		// for state vars
		private var _numberOfPages:uint;
		private var _picsPerPage:uint = 12;
		
		private var _curentPicIndex:uint;
		private var _curentPicsPage:uint;
		
		private var _hasNextPage = false;
		private var _hasPrevPage = false;
		
		private var _next:MovieClip;
		private var _prev:MovieClip;
		
		private var _limit:uint;
		//---------------------------------
		
		public var gallContent:Object = new Object;
		public var targetThumbs:MovieClip;
		
		public var selectTatget:GallSitePic;
		public var infoText:TextField;
		
		private var galleryPreview:GalleryBigPics;
		
		private var _elementsList:XMLList;
		
		private var _ellWidth:Number = 49;
		private var _ellHeight:Number = 20;
		
		private var _stepPix:Number = 3;
		
		private var _buttonsHolder:MovieClip;

		private var _zoomIn:GalleryButton;
		private var _zoomOut:GalleryButton;
		private var _delaySetter:GalleryIntervalSetter;
		
		private var _slide:GalleryButton;
		private var _slideShow:Boolean = false;
		
		private var _nextBig:MovieClip;
		private var _prevBig:MovieClip;
		
		public function SiteGallery():void
		{
			//trace(MainDocument.getData().page.(@id == 1).@name)
			//MainDocument.rootLink = 1;

			_next = getChildByName("next") as MovieClip;
			_prev = getChildByName("prev") as MovieClip;
			
			_buttonsHolder = MainDocument.getMainTimline().bottomHolder.getChildByName("buttonsHolder") as MovieClip;

			_zoomIn = _buttonsHolder.getChildByName("zoomIn") as GalleryButton;
			_zoomOut = _buttonsHolder.getChildByName("zoomOut") as GalleryButton;
			_slide = _buttonsHolder.getChildByName("slide") as GalleryButton;
			_delaySetter = _buttonsHolder.getChildByName("delaySetter") as GalleryIntervalSetter;
			
			_zoomIn.addEventListener(MouseEvent.CLICK, zoomInClickHandler);
			_zoomOut.addEventListener(MouseEvent.CLICK, zoomOutClickHandler);
			_slide.addEventListener(MouseEvent.CLICK, slideClickHandler);
			
			galleryPreview = MainDocument.getMainTimline().getChildByName("previewPics") as GalleryBigPics;
			
			_nextBig = galleryPreview.getChildByName("nextBT") as MovieClip;
			_prevBig = galleryPreview.getChildByName("prevBT") as MovieClip;
			
			_nextBig.addEventListener(MouseEvent.CLICK, nextBigPicHandler);
			_prevBig.addEventListener(MouseEvent.CLICK, prevBigPicHandler);
			
			_nextBig.addEventListener(MouseEvent.ROLL_OVER, overArrHandler);
			_nextBig.addEventListener(MouseEvent.ROLL_OUT, outArrHandler);
			
			_prevBig.addEventListener(MouseEvent.ROLL_OVER, overArrHandler);
			_prevBig.addEventListener(MouseEvent.ROLL_OUT, outArrHandler);
			
			galleryPreview.addEventListener("slideNextPic", nextSlideHandler);
			
			// update zoom btn
			galleryPreview.addEventListener("ZoomOut", updateZoom);
			galleryPreview.addEventListener("ZoomIn", updateZoom);
			galleryPreview.addEventListener("noZoomOut", updateZoom);
			galleryPreview.addEventListener("noZoomIn", updateZoom);
			_buttonsHolder.addEventListener("newInterval", newIntervaHandler);
			
			
			addEventListener("thumbSelected", thumbClickHandler);
			addEventListener("newSlide", newSlideHandler);
			
			ColorShortcuts.init();	
			
			MainDocument.getMainTimline().addEventListener("switchPage", switchPageHandler);
		}
		
		private function switchPageHandler(e:Event):void
		{
			_slideShow = false;
			_slide.gotoAndPlay("out")
		}
		
		public function init(initData:XML):void
		{
			
			setKoord(initData.@x, initData.@y);
			
			// content buttons
			_zoomOut.init(XML(initData.galleryControls.control.(@id == 1)));
			_zoomIn.init(XML(initData.galleryControls.control.(@id == 2)));
			_slide.init(XML(initData.galleryControls.control.(@id == 3)));
			_delaySetter.init(XML(initData.galleryControls.control.(@id == 4)));
			
			_curentPicIndex = 0;
			_curentPicsPage = 0;
			
			curentPic = 0;
			
			gallContent = {};
			
			_elementsList = initData.galleryData.elements();
			_numberOfPics = _elementsList.length();
			
			var data:XMLList = initData.galleryData;
			
			for (var i:uint = 0; i < _numberOfPics; i++)
			{
				gallContent["item" + i] = new Object();
				gallContent["item" + i].picPreview = String(data.pic.(@id == i).picPreview);
				gallContent["item" + i].bigPic = String(data.pic.(@id == i).bigPic);
				gallContent["item" + i].photoName = XML(data.pic.(@id == i).photoName);
			}
			
			_numberOfPages = Math.ceil(_numberOfPics / _picsPerPage);
			
			createThumbs(gallContent);
			
			galleryPreview.init(gallContent.item0.bigPic);
			
		}
		
		private function newIntervaHandler(e:CustomEvent):void
		{
			galleryPreview.setDelay(e.customNumber);
		}
		
		public function setKoord(newX:Number, newY:Number):void
		{
			x = newX;
			y = newY;
		}
		
		private function updateZoom(e:Event):void
		{
			if (e.type == "ZoomIn")
			{
				_zoomIn.alpha = 1;
				_zoomIn.mouseEnabled = true;
			}
			if (e.type == "ZoomOut")
			{
				_zoomOut.alpha = 1;
				_zoomOut.mouseEnabled = true;
			}
			
			if (e.type == "noZoomIn")
			{
				_zoomIn.alpha = 0.5;
				_zoomIn.mouseEnabled = false;
			}
			if (e.type == "noZoomOut")
			{
				_zoomOut.alpha = 0.5;
				_zoomOut.mouseEnabled = false;
			}
		}
		
		//  state functions
		
		private function createThumbs(obj:Object):void
		{
			if (targetThumbs)
				removeChild(targetThumbs);
			
			targetThumbs = new MovieClip();
			addChild(targetThumbs);
			
			updateButtons();
			
			var counter:uint = 0;
			var basicPosX:Number = 0;
			var basicPosY:Number = 0;
			
			var indexThumb:uint = _curentPicIndex;
			
			_limit = _picsPerPage;
			
			if (_curentPicsPage == (_numberOfPages-1))
				_limit = _numberOfPics - (_picsPerPage * (_numberOfPages - 1));
			
			while (counter < _limit)
			{
				var thumbnail:GallSitePic = new GallSitePic();
				thumbnail.init(gallContent["item" + indexThumb].picPreview, gallContent["item" + indexThumb].photoName, indexThumb);
				thumbnail.x = 0;
				thumbnail.y = basicPosY;
				
				thumbnail.name = String("thumb" + indexThumb);
				
				targetThumbs.addChild(thumbnail);
				
				basicPosY = basicPosY +_ellHeight + _stepPix;
				
				counter++;
				indexThumb++;
				_curentPicIndex++;
			}
			
			if (targetThumbs.getChildByName("thumb" + curentPic))
			{
				GallSitePic(targetThumbs.getChildByName("thumb" + curentPic)).setSelected();
				selectTatget = GallSitePic(targetThumbs.getChildByName("thumb" + curentPic));
			}
		}
		
		private function createNextArrListenes():void
		{
			_next.addEventListener(MouseEvent.ROLL_OVER, overArrHandler);
			_next.addEventListener(MouseEvent.ROLL_OUT, outArrHandler);
			_next.addEventListener(MouseEvent.CLICK, clickNextHandler);
		}
		
		private function createPrevArrListenes():void
		{
			_prev.addEventListener(MouseEvent.ROLL_OVER, overArrHandler);
			_prev.addEventListener(MouseEvent.ROLL_OUT, outArrHandler);
			_prev.addEventListener(MouseEvent.CLICK, clickPrevHandler);
		}
		
		private function removeNextArrListenes():void
		{
			_next.removeEventListener(MouseEvent.ROLL_OVER, overArrHandler);
			_next.removeEventListener(MouseEvent.ROLL_OUT, outArrHandler);
			_next.removeEventListener(MouseEvent.CLICK, clickNextHandler);
		}
		
		private function removePrevArrListenes():void
		{
			_prev.removeEventListener(MouseEvent.ROLL_OVER, overArrHandler);
			_prev.removeEventListener(MouseEvent.ROLL_OUT, outArrHandler);
			_prev.removeEventListener(MouseEvent.CLICK, clickPrevHandler);	
		}
		
		private function clickNextHandler(e:MouseEvent):void
		{
			if (_hasNextPage)
			{
				_curentPicsPage++;
				Tweener.addTween(targetThumbs, { alpha:0, time:0.5 } );
				createThumbs(gallContent);
			}
		}
		
		private function clickPrevHandler(e:MouseEvent):void
		{
			if (_hasPrevPage)
			{
				_curentPicIndex = _curentPicIndex - _limit - _picsPerPage;
				_curentPicsPage--;
				Tweener.addTween(targetThumbs, { alpha:0, time:0.5 } );
				createThumbs(gallContent);
			}
		}
		
		private function updateButtons():void
		{
			_hasNextPage = true;
			_hasPrevPage = true;
				
			if (_curentPicsPage == (_numberOfPages - 1))
			{
				_hasNextPage = false
				if (_next.currentLabel == "over")
					_next.gotoAndPlay("out")
			}
			
			if (_curentPicsPage == 0)
			{
				_hasPrevPage = false;
				if (_prev.currentLabel == "over")
					_prev.gotoAndPlay("out")
			}
				
			if (_hasNextPage)
			{
				createNextArrListenes();
				Tweener.addTween(_next, {alpha:1, time:0.5});
			}
			else
			{
				removeNextArrListenes();
				Tweener.addTween(_next, {alpha:0, time:0.5});
			}
			
			if (_hasPrevPage)
			{
				createPrevArrListenes();
				Tweener.addTween(_prev, {alpha:1, time:0.5});
			}
			else
			{
				removePrevArrListenes();
				Tweener.addTween(_prev, {alpha:0, time:0.5});
			}
		}
		
		//--------------------------------
		
		private function overArrHandler(e:MouseEvent):void
		{
			e.target.gotoAndPlay("over")
		}
		
		private function outArrHandler(e:MouseEvent):void
		{
			e.target.gotoAndPlay("out")
		}
		
		private function thumbClickHandler(e:Event):void
		{
			if (selectTatget)
			{
				selectTatget.setUnselected();
				selectTatget.gotoAndPlay("out");
			}
			
			selectTatget = GallSitePic(e.target);
			selectTatget.setSelected();
			//trace(GallSitePic(e.target).number)
			
			galleryPreview.next(gallContent["item" + GallSitePic(e.target).number].bigPic);
			
			curentPic = GallSitePic(e.target).number;
		}
		
		private function newSlideHandler(e:Event):void
		{
			selectTatget = GallSitePic(e.target);
		}
		
		private function zoomInClickHandler(e:MouseEvent):void
		{
			galleryPreview.dispatchEvent(new Event("zoomIn"));
		}
		
		private function zoomOutClickHandler(e:MouseEvent):void
		{
			galleryPreview.dispatchEvent(new Event("zoomOut"));
		}
		
		private function slideClickHandler(e:MouseEvent):void
		{
			e.target.setFlag(_slideShow)
			_slideShow = !_slideShow;
		}
		
		private function nextSlideHandler(e:Event):void
		{
			if (_slideShow)
			{
				curentPic++;
				if (curentPic == _numberOfPics)
				{
					curentPic = 0;
				}
					
				if(selectTatget)
				{
					selectTatget.setUnselected();
					selectTatget.gotoAndPlay("out");
				}
				
				selectTatget = null;
				
				galleryPreview.next(gallContent["item" + curentPic].bigPic);
				
				dispatchEvent(new Event("nextShow"));
			}
		}
		
		private function nextBigPicHandler(e:MouseEvent):void
		{
			curentPic++;
			if (curentPic == _numberOfPics)
			{
				curentPic = 0;
			}
				
			if(selectTatget)
			{
				selectTatget.setUnselected();
				selectTatget.gotoAndPlay("out");
			}
				
			selectTatget = null;
				
			galleryPreview.next(gallContent["item" + curentPic].bigPic);
				
			dispatchEvent(new Event("nextShow"));
		}
		
		private function prevBigPicHandler(e:MouseEvent):void
		{
			curentPic--;
			if (curentPic == 0)
			{
				curentPic = _numberOfPics;
			}
				
			if(selectTatget)
			{
				selectTatget.setUnselected();
				selectTatget.gotoAndPlay("out");
			}
				
			selectTatget = null;
				
			galleryPreview.next(gallContent["item" + curentPic].bigPic);
				
			dispatchEvent(new Event("nextShow"));
		}
	}
	
}