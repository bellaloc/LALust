package elements.MP3player
{
	import adobe.utils.CustomActions;
	import caurina.transitions.properties.TextShortcuts;
	import caurina.transitions.Tweener;
	import flash.display.MovieClip;
	import flash.events.Event; 
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.Sound; 
	import flash.media.SoundChannel;
    import flash.media.SoundMixer;
	import flash.net.URLRequest; 
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import caurina.transitions.properties.SoundShortcuts;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class  MP3Player extends MovieClip
	{
		public var objectList:Object = new Object;
		public var currentTrack = 0;
		public var playing = false;
		public var poused = false;
		
		public var curVol:Number = 0.5;
		
		private var _target:MovieClip;
		
		private var _startTime:Number;
		
		private var _numOfTracks:uint;
		private var _sound:Sound = new Sound();
		private var _channel:SoundChannel = new SoundChannel();
		
		private var _controls:MovieClip;
		private var _next:MovieClip;
		private var _previos:MovieClip;
		private var _stop:MovieClip;
		private var _play_pouse:MovieClip;
		
		private var _playerShowBtn:MovieClip
		private var _playerShowText:TextField;
		
		private var _bg:MovieClip;
		
		// bars time and load
		private var _progressBar:MovieClip;
		private var _trackBar:MovieClip
		private var _trackTimer:Timer = new Timer(3);
		private var _spectrumTimer:Timer = new Timer(50);
		
		private var _soundDragBar:MovieClip
		
		private var _spectrum:MovieClip;
		
		private var _playerOpen:Boolean = false;
		
		private var _tf:TextField;
		
		private var data:XML
		
		public function MP3Player():void
		{
			_spectrum = getChildByName("spectrum") as MovieClip;
			
			_bg = getChildByName("bg") as MovieClip;
			
			_controls = getChildByName("controls") as MovieClip;
			_next = _controls.getChildByName("next") as MovieClip;
			_previos = _controls.getChildByName("prev") as MovieClip;
			_stop = _controls.getChildByName("stopBt") as MovieClip;
			_play_pouse = _controls.getChildByName("play_pouse") as MovieClip;
			_target = getChildByName("itemsHold") as MovieClip;
			
			_tf = _target.getChildByName("tf") as TextField;
			
			_next.addEventListener(MouseEvent.CLICK, nextClicked);
			_previos.addEventListener(MouseEvent.CLICK, previosClicked);
			_stop.addEventListener(MouseEvent.CLICK, stopClicked);
			_play_pouse.addEventListener(MouseEvent.CLICK, play_pouseClicked);
			
			_next.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			_previos.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			_stop.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			_play_pouse.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			
			_next.addEventListener(MouseEvent.ROLL_OUT, outHandler);
			_previos.addEventListener(MouseEvent.ROLL_OUT, outHandler);
			_stop.addEventListener(MouseEvent.ROLL_OUT, outHandler);
			_play_pouse.addEventListener(MouseEvent.ROLL_OUT, outHandler);
			
			// bars time and load
			
			_progressBar = _controls.bar.getChildByName("bgLoad") as MovieClip;
			_trackBar = _controls.bar.getChildByName("drag") as MovieClip;
			
			_soundDragBar = _controls.soundBar.getChildByName("soundDrag") as MovieClip;
			_soundDragBar.buttonMode = true;
			
			_playerShowBtn = getChildByName("playerShowBtn") as MovieClip;
			_playerShowText = _playerShowBtn.txt.getChildByName("tf") as TextField;
			
			_playerShowBtn.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			_playerShowBtn.addEventListener(MouseEvent.ROLL_OUT, outHandler);
			_playerShowBtn.addEventListener(MouseEvent.CLICK, playerShowHandler);
			
			SoundShortcuts.init();
			
		}
		
		private function playerShowHandler(e:MouseEvent):void
		{
			if (!_playerOpen)
			{
				gotoAndPlay("show");
			}
			else {
				gotoAndPlay("hide");
			}
			
			_playerOpen = !_playerOpen;
		}
		
		private function soundSpectrumHandler(e:TimerEvent):void
		
		{
			if (_playerOpen)
			{
				var soundBytes:ByteArray = new ByteArray();
				try
				{
					SoundMixer.computeSpectrum(soundBytes, false, 1);
					for (var k:uint = 0; k < 5; k++ )
					{
						var sum:Number = 0;
						for (var i:uint = k; i < k + 51; i++ )
						{
							sum = sum + soundBytes.readFloat();
						}
						_spectrum["l" + k].height = Math.round((sum / 51) * 90);
						if (_spectrum["l" + k].height > 30)
							_spectrum["l" + k].height = 30;
					}
					
					for (k = 0; k < 5; k++ )
					{
						sum = 0;
						for (i = k; i < k + 51; i++ )
						{
							sum = sum + soundBytes.readFloat();
						}
						_spectrum["r" + k].height = Math.round((sum / 51) * 90);
						if (_spectrum["r" + k].height > 30)
							_spectrum["r" + k].height = 30;
					}
				}
				catch (e:Error) { }
			}
		}
		
		private function spectrumStoped():void
		{
			for (var i:uint = 0; i < 5; i++ )
			{
				Tweener.addTween(_spectrum["r" + i], { height:1, time:0.4 } );
				Tweener.addTween(_spectrum["l" + i], { height:1, time:0.4 } );
			}
		}
		
		public function init(dataObject:XML):void
		{
			data = XML(dataObject.dataMP3);
			_numOfTracks = data.elements().length();
			
			for (var i:uint = 0; i < _numOfTracks; i++)
			{
				objectList["item" + i] = new Object();
				objectList["item" + i].track = data.item.(@id == i).track;
				objectList["item" + i].file = String(data.item.(@id == i).file);
			}
			soundStart(0);
			
			setKoord(Number(dataObject.@x), Number(dataObject.@y));
			
			_tf.htmlText = String(objectList["item" + currentTrack].track);
			
			if (String(objectList["item" + currentTrack].track.@embedFonts) == "true") 
				_tf.embedFonts = true;
				
				
			_playerShowText.htmlText = String(dataObject.property.(@id == 1));
			_playerShowText.autoSize = TextFieldAutoSize.LEFT;
			_playerShowBtn.areaMc.width = _playerShowText.textWidth;
			
			if (String(dataObject.property.(@id == 1).@embedFonts) == "true") 
				_playerShowText.embedFonts = true;
			
		}
		
		public function setKoord(newX:Number, newY:Number):void
		{
			x = newX;
			y = newY;
		}
		
		// controls
		
		private function overHandler(e:MouseEvent):void
		{
			e.target.gotoAndPlay("over");
		}
		
		private function outHandler(e:MouseEvent):void
		{
			e.target.gotoAndPlay("out");
		}
		
		private function nextClicked(e:MouseEvent):void
		{
			nextTrack();
		}
		
		private function previosClicked(e:MouseEvent):void
		{
			previosTrack();
		}
		
		private function stopClicked(e:MouseEvent):void
		{
			playing = false;
			_channel.stop();
			_startTime = 0;
			_play_pouse.icon.gotoAndStop(2);
			
			_trackTimer.stop();
			_spectrumTimer.stop();
			spectrumStoped();
			
			_trackBar.x = 0;
		}
		
		private function play_pouseClicked(e:MouseEvent):void
		{
			if (playing)
			{
				_channel.stop();
				_startTime = _channel.position;
				_play_pouse.icon.gotoAndStop(2);
				playing = false;
				_spectrumTimer.stop();
			}
			else
			{
				_channel = _sound.play(_startTime);
				_play_pouse.icon.gotoAndStop(1);
				playing = true;
				_spectrumTimer.start();
			}
			
			_trackTimer.start();
			
			_channel.addEventListener(Event.SOUND_COMPLETE, songCompleteHandler);
			
			//_channel.soundTransform.volume = curVol;
			//Tweener.addTween(_channel, { _sound_volume: 0} );
			Tweener.addTween(_channel, { _sound_volume: curVol} );
		}
		//-----------------
		
		private function  previosTrack():void
		{
			currentTrack = currentTrack - 1;
			
			if (currentTrack < 0)
				currentTrack = _numOfTracks - 1;
				
			soundStart(currentTrack);
			
			_tf.htmlText = String(objectList["item" + currentTrack].track);
		
			if (String(objectList["item" + currentTrack].track.@embedFonts) == "true") 
				_tf.embedFonts = Boolean(data.@embedFonts);
			
		}
		
		private function  nextTrack():void
		{
			currentTrack = currentTrack + 1;
			
			if (currentTrack == _numOfTracks)
				currentTrack = 0;
				
			soundStart(currentTrack);
			
			_tf.htmlText = String(objectList["item" + currentTrack].track);
			
			if (String(objectList["item" + currentTrack].track.@embedFonts) == "true") 
				_tf.embedFonts = Boolean(data.@embedFonts);
		}
		
		// load events
		
		private function soundCompleteHandler(e:Event):void
		{
			_channel=_sound.play();
			playing = true;
			_play_pouse.icon.gotoAndStop(1);
			_channel.addEventListener(Event.SOUND_COMPLETE, songCompleteHandler);
			
			//Tweener.addTween(_channel, { _sound_volume: 0} );
			Tweener.addTween(_channel, { _sound_volume: curVol } );
			_soundDragBar.x = _soundDragBar.width / 2 * curVol;
			
			_trackTimer.start();
			_trackTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			_spectrumTimer.start();
			_spectrumTimer.addEventListener(TimerEvent.TIMER, soundSpectrumHandler);
			
			_trackBar.buttonMode = true;
			_trackBar.addEventListener(MouseEvent.MOUSE_DOWN, startDragEvent);
			_trackBar.addEventListener(MouseEvent.MOUSE_UP, stopDragEvent);
			
			_soundDragBar.addEventListener(MouseEvent.MOUSE_DOWN, startDragSound);
			_soundDragBar.addEventListener(MouseEvent.MOUSE_UP, stopDragSound);
			
		}
		private function soundProgressHandler(e:ProgressEvent):void
		{
			var persent:Number = Math.round((e.bytesLoaded / e.bytesTotal) * _progressBar.width);
			_progressBar.x = persent;
		}
		
		//------------------------
		private function songCompleteHandler(e:Event):void
		{
			nextTrack();
		}
		
		private function soundStart(num:uint):void
		{	
			if (_channel)
			{
				_channel.removeEventListener(Event.SOUND_COMPLETE, songCompleteHandler);
				try {
					_channel.stop();
					_sound.close();
				} catch(e:Error){
					_channel.stop();
				}	
			}
				
			var adr:String = objectList["item" + num].file;
			
			_sound = new Sound();
			_channel = new SoundChannel();
			_sound.load(new URLRequest(adr));
			
			_startTime = 0;
			playing = false;
			poused = false;
			
			_play_pouse.icon.gotoAndStop(2);
			
			_trackTimer.reset();
			_trackTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
			
			_spectrumTimer.reset();
			_spectrumTimer.removeEventListener(TimerEvent.TIMER, soundSpectrumHandler);
			
			spectrumStoped();
			
			_trackBar.buttonMode = false;
			_trackBar.removeEventListener(MouseEvent.MOUSE_DOWN, startDragEvent);
			_trackBar.removeEventListener(MouseEvent.MOUSE_UP, stopDragEvent);
			
			_soundDragBar.removeEventListener(MouseEvent.MOUSE_DOWN, startDragSound);
			_soundDragBar.removeEventListener(MouseEvent.MOUSE_UP, stopDragSound);
			
			_progressBar.x = 0;
			
			_sound.addEventListener(Event.COMPLETE, soundCompleteHandler);
			_sound.addEventListener(ProgressEvent.PROGRESS, soundProgressHandler);
			
		}
		// dragging tracks functions
		
		private function timerHandler(e:TimerEvent):void
		{
			_trackBar.x = Math.round((_channel.position * _progressBar.width) / _sound.length);
		}
		private function  startDragEvent(e:MouseEvent):void
		{
			_trackTimer.stop();
			_spectrumTimer.stop();
			
			_channel.stop();
			playing = false;
			
			_trackBar.startDrag(true, new Rectangle(0, 0, _progressBar.width, 0));
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragEvent);
		}
		
		private function stopDragEvent(e:MouseEvent):void
		{
			_trackBar.stopDrag();
			_startTime = (_trackBar.x * _sound.length) / _progressBar.width;
			
			_channel = _sound.play(_startTime);
			playing = true;
			
			_trackTimer.start();
			_spectrumTimer.start();
			
			_channel.addEventListener(Event.SOUND_COMPLETE, songCompleteHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragEvent);
		}
		
		// sound volume
		
		private function startDragSound(e:MouseEvent):void
		{
			_soundDragBar.startDrag(true, new Rectangle(0, 0, ( _soundDragBar.width / 2), 0));
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragSound);
		}
		
		private function stopDragSound(e:MouseEvent):void
		{
			_soundDragBar.stopDrag();
			curVol = _soundDragBar.x /( _soundDragBar.width / 2);
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragEvent);
			
			Tweener.addTween(_channel, { _sound_volume: curVol } );
			
			//Tweener.addTween(_channel, { _sound_volume: 0} );
			//Tweener.addTween(_channel, { _sound_volume: curVol,time:1} );
		}
	}
	
}