package {
	import com.litl.sdk.enum.View;
	import com.litl.sdk.enum.ViewDetails;
	import com.litl.sdk.enum.ViewSizes;
	import com.litl.sdk.message.*;
	import com.litl.sdk.service.LitlService;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;

	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	
	[SWF(backgroundColor="0", width="1280", height="800", frameRate="21")]
	public class MetaChannel extends Sprite
	{
		protected var service:LitlService;
		protected var loader:Loader;
		protected var currentView:DisplayObject;
		protected var currentWidth:Number;
		protected var currentHeight:Number;

		public function MetaChannel ()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			initialize();
		}

		protected function initialize () : void
		{
			service = new LitlService (this);
			service.connect ("litl_metachannel", "MetaChannel", "1.0", true);

			service.addEventListener (InitializeMessage.INITIALIZE, handleInitialize);
			service.addEventListener (PropertyMessage.PROPERTY_CHANGED, handlePropertyChanged);
			service.addEventListener (OptionsStatusMessage.OPTIONS_STATUS, handleOptionsStatus);
			service.addEventListener (UserInputMessage.GO_BUTTON_PRESSED, handleGoPressed);
			service.addEventListener (UserInputMessage.GO_BUTTON_HELD, handleGoHeld);
			service.addEventListener (UserInputMessage.GO_BUTTON_RELEASED, handleGoReleased);
			service.addEventListener (UserInputMessage.WHEEL_NEXT_ITEM, handleWheelNext);
			service.addEventListener (UserInputMessage.WHEEL_PREVIOUS_ITEM, handleWheelPrevious);
			service.addEventListener (UserInputMessage.MOVE_NEXT_ITEM, handleMoveNext);
			service.addEventListener (UserInputMessage.MOVE_PREVIOUS_ITEM, handleMovePrevious);
			service.addEventListener (ViewChangeMessage.VIEW_CHANGE, handleViewChange);
		}

		/**
		 * Called when the device has sent all our saved properties, and is ready for us to begin.
		 * @param eThe InitializeMessage instance.
		 *
		 */
		private function handleInitialize (e:InitializeMessage) : void
		{
			service.channelTitle = "Meta Channel";
			//service.channelIcon = "http://litl.com/cute.ico";
			service.channelItemCount = 1;
		}

		/**
		 * Called when the device has changed views. From focus to card view, for instance.
		 * @param eThe ViewChangeMessage instance.
		 *
		 */
		private function handleViewChange (e:ViewChangeMessage) : void
		{
			// When the device sends us a ViewChangeMessage, we should change our content
			// to match the new view.
			var newView:String = e.view;
			var newDetails:String = e.details;
			var viewWidth:Number = e.width;
			var viewHeight:Number = e.height;
			setView (newView, newDetails, viewWidth, viewHeight);
		}

		private function handlePropertyChanged (e:PropertyMessage) : void
		{
		}

		private function handleOptionsStatus (e:OptionsStatusMessage) : void
		{
		}

		private function handleGoPressed (e:UserInputMessage) : void
		{
		}

		private function handleGoHeld (e:UserInputMessage) : void
		{
		}

		private function handleGoReleased (e:UserInputMessage) : void
		{
		}

		private function handleWheelNext (e:UserInputMessage) : void
		{
		}

		private function handleWheelPrevious (e:UserInputMessage) : void
		{
		}

		private function handleMoveNext (e:UserInputMessage) : void
		{
		}

		private function handleMovePrevious (e:UserInputMessage) : void
		{
		}

		/**
		 * Set the current view. Create the view if it doesn't exist, and switch to it.
		 * @param newViewThe view constant.
		 * @param newDetailsThe view details.
		 * @see com.litl.sdk.enum.View
		 */
		public function setView (newView:String, newDetails:String, viewWidth:Number = 0, viewHeight:Number = 0) : void
		{
			trace("Setting view: " + newView + " " + newDetails + " (" + viewWidth + ", " + viewHeight + ")");

			if (!loader) {
				var request:URLRequest = new URLRequest ("fireworks.swf");
				//var request:URLRequest = new URLRequest ("AIRApp_48.png");
				//var request:URLRequest = new URLRequest ("http://github.com/images/modules/header/logov3.png");

				loader = new Loader ();
				loader.load (request);

				loader.contentLoaderInfo.addEventListener (Event.COMPLETE, resizeLoader);

			} else {
				resizeLoader (null);
			}

			// Remove the current view from the display list.
			if (contains (loader))
				removeChild (loader);

			switch (newView) {
			default:
				throw new Error ("Unknown view state");
				break;

			case View.CHANNEL:
				currentWidth = viewWidth > 0 ? viewWidth : ViewSizes.CHANNEL_WIDTH;
				currentHeight = viewHeight > 0 ? viewHeight : ViewSizes.CHANNEL_HEIGHT;
				break;

			case View.FOCUS:
				currentWidth = viewWidth > 0 ? viewWidth : ViewSizes.FOCUS_WIDTH;
				currentHeight = viewHeight > 0 ? viewHeight : ViewSizes.FOCUS_HEIGHT;
				break;

			case View.CARD:
				// TODO: Special case this
				currentWidth = viewWidth > 0 ? viewWidth : ViewSizes.CARD_WIDTH;
				currentHeight = viewHeight > 0 ? viewHeight : ViewSizes.CARD_HEIGHT;
				break;
			}

			if (!contains (loader))
				addChild(loader);

			if (newDetails == ViewDetails.OFFSCREEN) {
				// Optionally do something to "disable" the channel here, when the channel is offscreen for instance.
			} else {
			}
		}

		private function resizeLoader (evt:Event) : void
		{
			//loader.width = currentWidth;
			//loader.height = currentHeight;

			//MovieClip(loader.content).play();
		}
	}
}
