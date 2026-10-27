package elements.form
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Funkey
	 */
	public class  EmailForm extends MovieClip
	{
		private var contact_name:ContactTextField;
		private var contact_phone:ContactTextField;
		private var contact_email:ContactTextField;
		private var contact_subject:ContactTextField;
		private var contact_message:ContactTextField;
		private var message_status:TextField;
		
		private var timer:Timer;
		private var var_load:URLLoader = new URLLoader() ;
		private var URL_request:URLRequest = new URLRequest( "sendemail.php" );
		private var URL_vars:URLVariables;
		
		private var data:XML;
		
		public function EmailForm():void
		{
			contact_name = new ContactTextField(cName);
			contact_phone = new ContactTextField(cPhone);
			contact_email = new ContactTextField(cEmail);
			contact_subject = new ContactTextField(cSubject);
			contact_message = new ContactTextField(cMessage);
			
			message_status = cStatus;
			
			contact_name.tabIndex = 10;
			contact_phone.tabIndex = 12;
			contact_email.tabIndex = 13;
			contact_subject.tabIndex = 14;
			contact_message.tabIndex = 15;
			
			send_button.addEventListener(MouseEvent.CLICK, submit);
			reset_button.addEventListener(MouseEvent.CLICK, reset);
			
			URL_request.method = URLRequestMethod.POST;
			
		}
		
		public function init(dataObj:XML):void
		{
			data = dataObj;
			
			contact_name.setLable(data.property.(@id == 1));
			contact_phone.setLable(data.property.(@id == 2));
			contact_email.setLable(data.property.(@id == 3));
			contact_subject.setLable(data.property.(@id == 4));
			contact_message.setLable(data.property.(@id == 5));
			
			send_button.init(XML(data.controls.item.(@id == 1)));
			reset_button.init(XML(data.controls.item.(@id == 2)));
			
			setKoord(Number(data.@x), Number(data.@y));
		}
		
		public function setKoord(newX:Number, newY:Number):void
		{
			x = newX;
			y = newY;
		}
		
		private function submit(e:MouseEvent):void 
		{
			message_status.text = "sending...";
				
			var email_data:String = "name=" + contact_name._target.text
				+ "&phone=" + contact_phone._target.text
				+ "&email=" + contact_email._target.text
				+ "&subject=" + contact_subject._target.text
				+ "&message=" + contact_message._target.text;
				
			URL_vars = new URLVariables(email_data);
			URL_vars.dataFormat = URLLoaderDataFormat.TEXT;
			
			URL_request.data = URL_vars;
			
			var_load.load(URL_request);
			
			var_load.addEventListener(Event.COMPLETE, receive_response );
		}
		private function reset(e:MouseEvent):void 
		{
			message_status.text = "";
			
			contact_name.setLable(data.property.(@id==1));
			contact_phone.setLable(data.property.(@id==2));
			contact_email.setLable(data.property.(@id==3));
			contact_subject.setLable(data.property.(@id==4));
			contact_message.setLable(data.property.(@id==5));
		}
		private function receive_response(e:Event):void 
		{
			var loader:URLLoader = URLLoader(e.target);
			var email_status = new URLVariables(loader.data).success;
			if ( email_status == "yes" ) 
			{
				message_status.text = "Your message send";
				timer = new Timer(500);
				timer.addEventListener(TimerEvent.TIMER, on_timer);
				timer.start();
			} 
			else 
			{
				message_status.text = "Message error";
			}
		}
		private function on_timer(te:TimerEvent):void 
		{
			if ( timer.currentCount >= 10 ) 
			{
				message_status.text = "";
				
				contact_name.setLable(data.property.(@id==1));
				contact_phone.setLable(data.property.(@id==2));
				contact_email.setLable(data.property.(@id==3));
				contact_subject.setLable(data.property.(@id==4));
				contact_message.setLable(data.property.(@id==5));
				
				timer.removeEventListener(TimerEvent.TIMER, on_timer);
			}
		}
	}
	
}