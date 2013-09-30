// ActionScript file 2013-9-29, 黄记新
import com.bingya.asset.controller.AssetEvent;
import com.bingya.asset.model.AssetProxy;
import com.bingya.common.Global;

import components.AssetBusiDomain;
import components.FileUploadTitleWindow;
import components.SettingPropPanel;
import components.TestEnvPanel;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.events.ActivityEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.events.NetStatusEvent;
import flash.events.StatusEvent;
import flash.events.TimerEvent;
import flash.external.ExternalInterface;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.media.Camera;
import flash.media.Microphone;
import flash.media.SoundTransform;
import flash.media.Video;
import flash.net.FileReference;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.FlexGlobals;
import mx.events.FlexEvent;
import mx.events.SandboxMouseEvent;
import mx.managers.PopUpManager;
import mx.utils.UIDUtil;

import spark.components.Image;

/**
 * 网络连接
 */ 
private var _netConnection:NetConnection; 
/**
 * 视频流。
 */ 
private var _netStream:NetStream;

private var localVideo:Video;
/**
 * url地址。
 */ 
private var rtmpRecordUrl:String;

/**
 * 摄像头。
 */ 
private var camera:Camera; 

/**
 * 麦克风。
 */ 
private var mic:Microphone; 

[Bindable]
private var volumeTransform:SoundTransform;  

private var assetProxy:AssetProxy = new AssetProxy();

[Bindable]
private var pathsArrcol:ArrayCollection = new ArrayCollection();

[Bindable]
private var currentPageIndex:int = -1;

//计时器。
private var timer:Timer;
//视频流日期
private var time:Number;

//记录视频时间点。
private var startTime:Number = 0;
private var endTime:Number = 0;
private var offsetTime:Number = -1;//录制视频的时间有偏差，所以开始的时候用这个记录偏差，后面纠正偏差。
private var titleTime:Number = 0;

[Bindable]
private var isRecording:Boolean; //标志变量，是否在录制。

//数据
private var presentionXml:XML;

//讲义id。
private var assetId:int= -1;

[Bindable]
public var userId:int = 1;

[Bindable]
public var courseId:int = 1;

private var titleXml:XML;

private var courseFileDir:String;
/**
 * 初始化。
 */ 
protected function application1_creationCompleteHandler(event:FlexEvent):void
{
	// 设置初始化参数。
	Global.getInstance().setUrl();
	var urlloader:URLLoader = new URLLoader();
	urlloader.load(new URLRequest("config.xml"));
	urlloader.addEventListener(Event.COMPLETE,function loaderComplete(event:Event):void{
		var xml:XML = new XML(urlloader.data);
		if(xml){
			Global.getInstance().swfAppUrl = xml.swfAppUrl[0];
			Global.getInstance().endPoint = xml.endPoint[0];
			Global.getInstance().FileUploadPath = xml.fileUpload[0];
			Global.getInstance().recordPath = xml.record[0];
		}
	});
	urlloader.addEventListener(IOErrorEvent.IO_ERROR,function loaderIoError(event:IOErrorEvent):void{
		Alert.show("加载不了config.xml配置文件");
	});
	
	var uId:int = FlexGlobals.topLevelApplication.parameters.userId;  
	var courseId:int = FlexGlobals.topLevelApplication.parameters.courseId; 
	courseFileDir = FlexGlobals.topLevelApplication.parameters.courseFileDir;
	
	if(uId)
		this.userId = uId;
	if(courseId)
		this.courseId = courseId;
	
	_netConnection = new NetConnection();
	_netConnection.addEventListener(NetStatusEvent.NET_STATUS, handlerNetStatus);
	var url:String = Global.getInstance().recordPath+userId;
	_netConnection.connect(url);
	
	assetProxy.addEventListener(AssetEvent.saveXmlStringToFileFault,saveXmlStringToFileFault);
	assetProxy.addEventListener(AssetEvent.saveXmlStringToFileResult,saveXmlStringToFileResult);
}

/**
 * 字符串流。
 */ 
private function doStartRecording() : void
{
	if(openVedioBtn.selected){
		if(camera){
//			localVideo.attachCamera(null);
//			localVideo.attachCamera(camera);
			_netStream.attachCamera(camera,1); 
		}
	}else{
		_netStream.attachCamera(null); 
	}
	
	time = new Date().time;
	this._netStream.close();
	this._netStream.publish( userId+"_"+time, "record" );
}

/**
 * 网络连接响应
 */ 
protected function onNetStatus(event:NetStatusEvent):void
{
	handlerNetStatus(event);
}

private function handlerNetStatus(event:NetStatusEvent) : void 
{
	var info:Object = event.info;
	switch(info.code) 
	{
		case "NetConnection.Connect.Success":	
			this._netStream = new NetStream(this._netConnection);
			this._netStream.client = new Object();
			
			initCamera();
			initMicphpne();
			break;
		
		case "NetConnection.Connect.Rejected":
			Alert.show("拒绝连接","注意");
			break;
		
		case "NetConnection.Connect.Failed":
			Alert.show("连接失败","注意");
			break;
		
		case "NetConnection.Connect.Closed":
			break;
	}
}

/**
 * 初始化摄像头摄像头。
 */ 
protected function initCamera():void{
	//保证有一个摄像头
	camera = Camera.getCamera();
	if ( camera == null )
	{
		if ( Camera.names.length > 0 )
		{
			Alert.show( '其它程序正占用摄像头', 'Error' );
		}
		else
		{
			Alert.show( '要安装摄像头哦', 'Error' );
		}
	}
	else
	{
//		camera.addEventListener(StatusEvent.STATUS, this.camonStatusHandler);
//		camera.addEventListener(ActivityEvent.ACTIVITY, this.camactivityHandler);
		camera.setMode(320, 240, 15);
		camera.setQuality(40 * 1000, 0);
		camera.setKeyFrameInterval(48);
		camera.setMotionLevel(0);
	}
}

private function camactivityHandler(event:ActivityEvent) : void
{
	camera.removeEventListener(ActivityEvent.ACTIVITY, this.camactivityHandler);
	return;
}// end function

private function camonStatusHandler(event:StatusEvent) : void
{
	if (camera.muted)
	{
	}
	else
	{
		camera.removeEventListener(StatusEvent.STATUS, this.camonStatusHandler);
	}
	return;
}// end function

protected function initMicphpne():void{
	mic = Microphone.getMicrophone();
	if(!volumeTransform){
		volumeTransform = new SoundTransform();
		this.volumeBar.value = volumeTransform.volume;
		this._netStream.soundTransform=volumeTransform;
	}
	if ( mic == null )
	{
		if ( Microphone.names.length > 0 )
		{
			Alert.show( '其它程序正占用麦克风', 'Error' );
		}
		else
		{
			Alert.show( '要安装麦克风哦', 'Error' );
		}
	}
	else
	{
		mic.setSilenceLevel(0);
		this._netStream.attachAudio(mic);
	}
}
/**
 * 结束按钮响应函数。
 */ 
protected function endRecordBtn_clickHandler(event:MouseEvent):void
{
	if(isRecording){
		if(timer){
			timer.stop();
			timer = null;
		}
		
		if(pathsArrcol && pathsArrcol.length!=0){
			var xmllist:XMLList = presentionXml.Courseware;
			var path:String = pathsArrcol[currentPageIndex];
			if(path.indexOf("/")!= -1){
				path = path.substring(path.lastIndexOf("/")+1,path.length);
			}
			startTime = endTime;
			endTime  = Math.floor((this._netStream.time-offsetTime)*1000);
			
			var titleStr:String ="";
			if(this.titleXml){
				var temp:XML = titleXml.Page.(@Id==(currentPageIndex+1))[0];
				titleStr = temp.Title;
			}
			titleStr == ""?"第"+(currentPageIndex+1)+"节":titleStr;
			
			var xml:XML = new XML('<Section id="'+(currentPageIndex+1)+'">' +
				'<title>'+titleStr+'</title>' +
				'<time>' +
				'<start>'+startTime+'</start><end>'+endTime+'</end>' +
				'</time><type>slide</type>' +
				'<source>'+path+'</source>' +
				'<show>1</show><pads />' +
				'<poss /><sticks><stick long="1100" ptf="31200">' +
				'</stick></sticks></Section>');
			presentionXml.Courseware[0].appendChild(xml);
		}	
		
		isRecording = false;
		this._netStream.publish();					
		offsetTime = -1;
	}
	
	/* if(currentPageIndex != -1){
	assetProxy.saveXmlStr(presentionXml.toString(),userId,courseId,userId+"_"+time,assetId);
	}else{
	assetProxy.saveXmlStr(presentionXml.toString(),userId,courseId,userId+"_"+time,assetId);
	} */
	assetProxy.saveXmlStr(presentionXml.toString(),userId,courseId,userId+"_"+time,assetId);
	
	//				assetProxy.test();
	assetProxy.addEventListener(AssetEvent.saveXmlStrFault,saveXmlStrFault);
	assetProxy.addEventListener(AssetEvent.saveXmlStrResult,saveXmlStrResult);
}

protected function saveXmlStringToFileFault(event:AssetEvent):void{
	Alert.show("保存失败");
}

protected function saveXmlStringToFileResult(event:AssetEvent):void{
	Alert.show("保存成功");
}

protected function saveXmlStrFault(event:AssetEvent):void{
	Alert.show("保存失败");
}

protected function saveXmlStrResult(event:AssetEvent):void{
	if(event.object){
		ExternalInterface.call("saveXmlSuccess",event.object.toString());
	}else{
		ExternalInterface.call("saveXmlSuccess");
	}

}

/**
 * 生成presentation.xml.
 */ 
private function generatePresentationXml():void{
	presentionXml = new XML('<Presentation>' +
		'<PlayerProperties id="PP">' +
		'<Skin id="PP_S" />' +
		'<Loop id="PP_L">false</Loop>' +
		'<Completion id="PP_C">http://www.iemaker.com</Completion>' +
		'<Live id="PP_LIVE">false</Live>' +
		'<Vote id="PP_VOTE">true</Vote>' +
		'<Show id="PP_SHOW">true</Show><PlayModel />' +
		'</PlayerProperties><BuiltinProperties id="BP">' +
		'<Title id="BP_T">新建课件2</Title><Keywords id="BP_K" />' +
		'<Description id="BP_D">无</Description><PresenterName id="BP_P" />' +
		'<PresenterCompany id="BP_PC" /><PresenterEmail id="BP_PE" />' +
		'<PresenterBio id="BP_PB" />' +
		'<PresenterPhoto id="BP_PP">head.jpg</PresenterPhoto>' +
		'</BuiltinProperties><Video>'+userId+'_'+time+'</Video><Courseware id="CCS"/></Presentation>');
	
	if(currentPageIndex != -1){
		
	}
}

/**
 * 查询讲义，上传讲义，删除讲义。
 */ 
protected function openFileBtn_clickHandler(event:MouseEvent):void
{
	var fileUploadTitleWindow:FileUploadTitleWindow = PopUpManager.createPopUp(this,FileUploadTitleWindow,true) as FileUploadTitleWindow;
	PopUpManager.centerPopUp(fileUploadTitleWindow);
	fileUploadTitleWindow.userId = userId as int;
	fileUploadTitleWindow.courseId = courseId as int;
	fileUploadTitleWindow.refresh();
	fileUploadTitleWindow.confirmBtn.addEventListener(MouseEvent.CLICK, function onOpenBtnClick(event:MouseEvent):void{
		var item:Object = fileUploadTitleWindow.dataGrid.selectedItem;
		if(item){
			if(item.hasOwnProperty("id")){
				var itemId:* = item["id"];
			}
			
			if(itemId){
				assetId = new int(itemId);
			}
			
			assetProxy.getPathsById(item.id);
			assetProxy.addEventListener(AssetEvent.getPathsByIdFault,getPathsByIdFault);
			assetProxy.addEventListener(AssetEvent.getPathsByIdResult,getPathsByIdResult);
		}
		PopUpManager.removePopUp(fileUploadTitleWindow);
	});
}

protected function getPathsByIdFault(event:AssetEvent):void
{
	Alert.show( event.object.toString() );
}

protected function getPathsByIdResult(event:AssetEvent):void
{
	var assetBusiDomain:AssetBusiDomain;
	if(event.object){
		if(event.object["paths"] is Array){
			assetBusiDomain = new AssetBusiDomain(event.object["titleXmlString"] as String,new ArrayCollection(event.object["paths"] as Array));
		}else if(event.object["paths"] is ArrayCollection){
			assetBusiDomain = new AssetBusiDomain(event.object["titleXmlString"] as String,event.object["paths"] as ArrayCollection);
		}
	}
	
	var arrcol:ArrayCollection;
	if(assetBusiDomain){
		if(assetBusiDomain.paths)
			arrcol = assetBusiDomain.paths;
		if(assetBusiDomain.titleXmlString!=null && assetBusiDomain.titleXmlString!=""){
			this.titleXml = new XML(assetBusiDomain.titleXmlString);
		}else{
			this.titleXml = null;
		}
	}
	
	for (var i:int = 0; i < arrcol.length; i++) 
	{
		arrcol[i] = Global.getInstance().swfAppUrl+arrcol[i];
	}
	
	pathsArrcol = arrcol;
	currentPageIndex = -1;
	if(arrcol && arrcol.length>0){
		swfLoader.source = arrcol[0];
		currentPageIndex = 0;
	}
}

/**
 * 打开视频。
 */ 
protected function openVedioBtn_clickHandler(event:MouseEvent):void
{
	if (openVedioBtn.selected){
		if(camera){
			//捕获摄像头，并且将摄像头画面渲染到video对象。
			localVideoDisplay.attachCamera(camera);
			videoDisColor.alpha = 0;
			//流渲染摄像头。
			_netStream.attachCamera(camera); 
		}
	} else{
		_netStream.attachCamera(null); 
		localVideoDisplay.attachCamera(null);
		videoDisColor.alpha = 1;
	} 
}

/**
 * 开始按钮响应函数。
 */
protected function startRecordBtn_clickHandler(event:MouseEvent):void
{
	if(isRecording){
		startRecordBtn.selected = true;
		return;
	}
	
	this.titleTime = 0;
	
	doStartRecording();
	generatePresentationXml();
	timer = new Timer(1000);
	timer.start();
	var sTime:Number = new Date().time;
	timer.addEventListener(TimerEvent.TIMER,function ontimer(event:TimerEvent):void{
		
		var eTime:Number = new Date().time;
		var recordTime:Number = eTime-sTime;
		titleTime = recordTime;
		recordTime/=1000;
//		titleTime = _netStream.time;
//		if(offsetTime == -1){
//			offsetTime = _netStream.time;
//		}
//		titleTime-= offsetTime;
		var hour:Number = Math.floor(recordTime/3600);
		var minu:Number = Math.floor((recordTime%3600)/60);
		var sec:Number = Math.floor(((recordTime%3600)%60)%60);
		var text:String = "";
		if(hour< 10){
			text+="0"+hour+":";
		}else{
			text+=hour+":";
		}
		if(minu< 10){
			text+="0"+minu+":";
		}else{
			text+=minu+":";
		}
		if(sec< 10){
			text+="0"+sec+"";
		}else{
			text+=sec+"";
		}
		timeLabel.text = text;
		
		if(titleTime > 120*1000){
			endRecordBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		} 
	});
	
	isRecording = true;
	offsetTime = -1;
	startTime = endTime = 0;
//	endTime  = Math.floor(this._netStream.time*1000);
}

/**
 * 上一页翻页
 */ 
protected function lastBtn_clickHandler(event:MouseEvent):void
{
	if(pathsArrcol && pathsArrcol.length>0){
		if(currentPageIndex-1 >=0){
			if(presentionXml){//录制状态，生成XML节点。
				if(isRecording){
					var path:String = pathsArrcol[currentPageIndex];
					if(path.indexOf("/")!= -1){
						path = path.substring(path.lastIndexOf("/")+1,path.length);
					}
					
					startTime = endTime;
					endTime  = titleTime;
//					endTime  = Math.floor((this._netStream.time-offsetTime)*1000);
					var titleStr:String ="";
					if(this.titleXml){
						var temp:XML = titleXml.Page.(@Id==(currentPageIndex-1))[0];
						if(temp){
							titleStr = temp.Title;
						}
					}
					titleStr == ""?"第"+(currentPageIndex-1)+"节":titleStr;
					
					var xml:XML = new XML('<Section id="'+(currentPageIndex-1)+'">' +
						'<title>'+titleStr+'</title>' +
						'<time>' +
						'<start>'+startTime+'</start><end>'+endTime+'</end>' +
						'</time><type>slide</type>' +
						'<source>'+path+'</source>' +
						'<show>1</show><pads />' +
						'<poss /><sticks><stick long="1100" ptf="31200">' +
						'</stick></sticks></Section>');
					presentionXml.Courseware[0].appendChild(xml);
				}
			}
			
			currentPageIndex-=1;
			
			deleteGraphicBtn_clickHandler(event);//翻页清空画笔
		}
		swfLoader.source = pathsArrcol[currentPageIndex];
	}
}

/**
 * 下一页翻页。
 */ 
protected function nextBtn_clickHandler(event:MouseEvent):void
{
	if(pathsArrcol && pathsArrcol.length>0){
		if(currentPageIndex+1 < pathsArrcol.length){
			if(presentionXml){//录制状态，生成XML节点。
				if(isRecording){
					var path:String = pathsArrcol[currentPageIndex];
					if(path.indexOf("/")!= -1){
						path = path.substring(path.lastIndexOf("/")+1,path.length);
					}
					
					startTime = endTime;
//					endTime  = Math.floor((this._netStream.time-offsetTime)*1000);
					endTime  = titleTime;
					var titleStr:String ="";
					if(this.titleXml){
						var temp:XML = titleXml.Page.(@Id==(currentPageIndex+1))[0];
						if(temp){
							titleStr = temp.Title;
						}
					}
					
					titleStr == ""?"第"+(currentPageIndex+1)+"节":titleStr;
					var xml:XML = new XML('<Section id="'+(currentPageIndex+1)+'">' +
						'<title>'+titleStr+'</title>' +
						'<time>' +
						'<start>'+startTime+'</start><end>'+endTime+'</end>' +
						'</time><type>slide</type>' +
						'<source>'+path+'</source>' +
						'<show>1</show><pads />' +
						'<poss /><sticks><stick long="1100" ptf="31200">' +
						'</stick></sticks></Section>');
					presentionXml.Courseware[0].appendChild(xml);
				}
			}
			
			currentPageIndex+=1;
			
			deleteGraphicBtn_clickHandler(event);//翻页清空画笔
		}
		swfLoader.source = pathsArrcol[currentPageIndex];
	}
}


/**
 * 音量调节。
 */
protected function volumeBar_changeHandler(event:Event):void
{
	if(volumeTransform){
		if(this._netStream && this._netStream.soundTransform){
			this._netStream.soundTransform.volume = volumeBar.value;
		}
	}
}


/**
 * 保存生成的xml到本地。 
 * @param event
 * 
 */
protected function saveXmlBtn_clickHandler(event:MouseEvent):void
{
	var fileRef:FileReference = new FileReference();
	fileRef.save(presentionXml.toString(),"presentation.xml");
}

/**
 * 测试按钮响应函数。
 */ 
protected function testEvnBtn_clickHandler(event:MouseEvent):void
{
	var testEnvPanel:TestEnvPanel = PopUpManager.createPopUp(this,TestEnvPanel,true) as TestEnvPanel;
	PopUpManager.centerPopUp(testEnvPanel);
	testEnvPanel.localVideoDisplay.attachCamera(camera);
}

/**
 * 设置按钮响应函数。
 */ 
protected function settingBtn_clickHandler(event:MouseEvent):void
{
	var settingPropPanel:SettingPropPanel = PopUpManager.createPopUp(this,SettingPropPanel,true) as SettingPropPanel;
	PopUpManager.centerPopUp(settingPropPanel);
	settingPropPanel.camera  = this.camera;
	settingPropPanel.mic  = this.mic;
	settingPropPanel.mic.setLoopBack(true);
	settingPropPanel.localVideoDisplay.attachCamera(camera);
	settingPropPanel.saveBtn.addEventListener(MouseEvent.CLICK,function saveBtnClick(event:MouseEvent):void{
		PopUpManager.removePopUp(settingPropPanel);
	});
}

/**
 * 暂停视频流录制。
 */ 
protected function pauseBtn_clickHandler(event:MouseEvent):void
{
	if (pauseBtn.selected){
		if(this._netStream){
			this._netStream.pause();
			pauseBtn.label = "继续";
			if(timer){
				timer.stop();
			}
		}
	} else{
		if(this._netStream){
			this._netStream.resume();
			if(timer){
				timer.start();
			}
		}
		pauseBtn.label = "暂停";
	} 
}


/**
 * 停止。
 */ 
protected function stopRecordBtn_clickHandler(event:MouseEvent):void
{
	if(isRecording){
		if(timer){
			timer.stop();
			timer = null;
		}
		
		isRecording = false;
		
		this._netStream.publish();
		offsetTime = -1;
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
////// 画笔功能
/////////////////////////////////////////////////////////////////////////////////////////////////////////

private var content:BitmapData;
private var bitmap:Bitmap;
private var image:Image;
private var action:int;
private var clearAll:int = 1;

/**
 * 画笔
 */ 
protected function graphicBtn_clickHandler(event:MouseEvent):void
{
	if(!image){
		image = new Image();
		
		if(!image.source){
			content = new BitmapData(drawingGroup.width,drawingGroup.height,true,0x00FFFFFF);
			//把content显示出来
			bitmap = new Bitmap(content);
			image.source = bitmap;
		}
		
		drawingGroup.addElement(image);
	}
	drawingGroup.addEventListener(MouseEvent.MOUSE_DOWN,ondrawingGroupMouseDown);
	action = 0;
	graphicGroup.visible = true;
}

/**
 * 画笔层鼠标按下。
 */ 
protected function ondrawingGroupMouseDown(event:MouseEvent):void
{
	var graphics:Graphics = graphicGroup.graphics;
	graphics.lineStyle(sizeHSlider.value,colorPicker.selectedColor);
	graphics.moveTo(graphicGroup.mouseX,graphicGroup.mouseY);
	
	var displayObject:DisplayObject = systemManager.getSandboxRoot();  
	displayObject.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler, true);  
	displayObject.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseDragHandler, true);  
	displayObject.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, this.mouseUpHandler, true);  
	displayObject.addEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, this.mouseDragHandler, true);  
	systemManager.deployMouseShields(true);  
}

protected function mouseDragHandler(event:Event):void  
{  
	var graphics:Graphics = graphicGroup.graphics;
	if(0>graphicGroup.mouseX || graphicGroup.mouseX>graphicGroup.width || 0>graphicGroup.mouseY || graphicGroup.mouseY>graphicGroup.height){
		return;
	}else{
		graphics.lineTo(graphicGroup.mouseX,graphicGroup.mouseY);
		if(action == 1){
			content.draw(graphicGroup,new Matrix(),new ColorTransform(),BlendMode.ERASE);
		}
	}
}  

protected function mouseUpHandler(event:Event):void  
{  
	if(action == 0){
		content.draw(graphicGroup,new Matrix(),new ColorTransform(),BlendMode.NORMAL,new Rectangle(0,0,graphicGroup.width,graphicGroup.height))				
	}
	
	var graphics:Graphics = graphicGroup.graphics;
	graphics.clear();
	
	var displayObject:DisplayObject=systemManager.getSandboxRoot();  
	displayObject.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler, true);  
	displayObject.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseDragHandler, true);  
	displayObject.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, this.mouseUpHandler, true);  
	displayObject.removeEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, this.mouseDragHandler, true);  
	systemManager.deployMouseShields(false);  
}  

/**
 * 橡皮擦功能
 */ 
protected function ereserBtn_clickHandler(event:MouseEvent):void
{
	action = 1;
	graphicGroup.visible = false;
}

protected function sizeHSlider_changeHandler(event:Event):void
{
	var graphics:Graphics = graphicGroup.graphics;
	graphics.lineStyle(sizeHSlider.value,colorPicker.selectedColor);
}

/**
 * 删除画笔。
 */ 
protected function deleteGraphicBtn_clickHandler(event:MouseEvent = null):void
{
	if(image){
		image.source = null;
		content = new BitmapData(drawingGroup.width,drawingGroup.height,true,0x00FFFFFF);
		//把content显示出来
		bitmap = new Bitmap(content);
		image.source = bitmap;
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
////// 
/////////////////////////////////////////////////////////////////////////////////////////////////////////
