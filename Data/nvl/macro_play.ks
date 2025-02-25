;-------------------------------------------------------------------------------------------
;封装的宏,对应于指令编辑器，可以根据自己的需求修改
;-------------------------------------------------------------------------------------------
*start
;-------------------------------------------------------------------------------------------
;★人名显示基础
;-------------------------------------------------------------------------------------------
[macro name=npc]

[nowait]
[layopt layer="message0" visible="true"]
[current layer="message0"]
[er]

;修改姓名显示相对位置的地方
;去掉下面这行的;，就可以用了，坐标可以为负值
;【记得后面还有要把对话文字位置改回来的地方】
;[locate x=-50 y=0]

;使用人名默认颜色
[eval exp="setfont()"]

;假如特别设定了颜色，使用传入的颜色值
[font color=%color]

;非主角
[if exp="mp.id!='主角'"]
[emb exp="mp.id"]
[endif]

;为主角，没姓名时不显示
[if exp="mp.id=='主角'"]

[emb exp="f.姓"][emb exp="f.名"]

[endif]

[resetfont]

[r]
[endnowait]

;可以这里再把显示位置改回来
;[locate x=0 y=0]

;附加显示
[backlay]
;头像
[if exp="mp.face!=void"]
[image layer=8 page="back" storage=%face visible="true"]
;left/top位置可以自己调整，可以用数字，这里是根据编辑器设定的值，按底边中点对齐
[layopt layer=8 page="back" left=&"(int)f.config_dia.face.left-kag.back.layers[8].width\2" top=&"(int)f.config_dia.face.top-kag.back.layers[8].height"]
[endif]
;立绘
[if exp="mp.fg!=void"]
;在原位置显示图片
[eval exp="mp.layer='0'" cond="mp.layer==''"]
[eval exp="mp.left=kag.fore.layers[mp.layer].left"]
[eval exp="mp.top=kag.fore.layers[mp.layer].top"]
[image layer=%layer page="back" storage=%fg left=%left top=%top visible="true"]
[endif]
[trans method="crossfade" time=100]
[wt]

[endmacro]
;------------------------------------------------------------------
;★准备选项
;------------------------------------------------------------------
[macro name=selstart]
[hr]
[backlay]
;隐藏对话层、消除头像
[if exp="mp.hidemes"]
[rclick enabled="false"]
[layopt layer="message0" visible="false" page=back]
[freeimage layer=8 page=back]
[endif]
;隐藏按钮层
[if exp="mp.hidesysbutton"]
[rclick enabled="false"]
[hidesysbutton]
[endif]
;显示选项层
[frame layer="message1" page="back"]
[current layer="message1" page="back"]
[nowait]
[endmacro]
;------------------------------------------------------------------
;★按钮选项
;------------------------------------------------------------------
[macro name=selbutton]
;显示选项按钮
[eval exp="createSelbutton(mp)"]
[endmacro]
;------------------------------------------------------------------
;★等待选择-选项
;------------------------------------------------------------------
[macro name=selend]
[endnowait]
;假如是限时选项，强制将系统菜单无效化
[if exp="mp.timeout"]
[history enabled="false"]
[rclick enabled="false"]
[hidesysbutton]
[endif]
[trans method=%method|crossfade time=%time|300 rule=%rule|1 from=%from stay=%stay]
[wt canskip=%canskip]
;限时选项处理
[if exp="mp.timeout"]
[timeout time=%outtime storage=%storage target=%target]
[endif]
[if exp="mp.timebar"]
[timebar bar=%bar x=%x y=%y time=%outtime width=%width bgimage=%bgimage bgx=%bgx bgy=%bgy]
[endif]
[s]
[endmacro]
;------------------------------------------------------------------
;★清理选项
;------------------------------------------------------------------
[macro name=clsel]
[rclick enabled="true"]
[history enabled="true"]
[backlay]
[layopt layer="message1" visible="false" page="back"]

;恢复对话框与系统按钮
[layopt layer="message0" visible="true" page=back]
;显示系统按钮层
[showsysbutton]
[trans method=%method|crossfade time=%time|100 rule=%rule|1 from=%from stay=%stay]
[wt canskip=%canskip]
;返回对话
[current layer="message0"]
[endmacro]
;------------------------------------------------------------------
;★文字连接
;------------------------------------------------------------------
[macro name=links]
[link *][ch text=%text][endlink]
[endmacro]

;------------------------------------------------------------------
;★等待
;------------------------------------------------------------------
[macro name=lr]
[l][r]
[endmacro]

[macro name=w]
;可在这里加入等待语音播放完毕的指令
[endvo]
[p]
[stopse buf="1"]
[hr]
[endmacro]
;------------------------------------------------------------------
;★普通对话框(含头像)
;------------------------------------------------------------------
[macro name=dia]
[rclick enabled="true"]
[history enabled="true"]
[backlay]
[freeimage layer=8 page="back"]
[current layer="message0" page="back"]
[position page="back" layer="message0" visible="true" frame=&"f.config_dia.dia.frame" left=&"f.config_dia.dia.left" top=&"f.config_dia.dia.top" marginl=&"f.config_dia.dia.marginl" marginr=&"f.config_dia.dia.marginr" margint=&"f.config_dia.dia.margint" marginb=&"f.config_dia.dia.marginb"]
;显示系统按钮层
[showsysbutton]
[trans method="crossfade" time=200]
[wt]
[current layer="message0" page="fore"]
[endmacro]
;------------------------------------------------------------------
;★全屏对话框(不含头像)
;------------------------------------------------------------------
[macro name=scr]
[rclick enabled="true"]
[history enabled="true"]
[backlay]
[freeimage layer=8 page="back"]
[current layer="message0" page="back"]
[position page="back" layer="message0" visible="true" frame=&"f.config_dia.scr.frame" left=&"f.config_dia.scr.left" top=&"f.config_dia.scr.top" marginl=&"f.config_dia.scr.marginl" marginr=&"f.config_dia.scr.marginr" margint=&"f.config_dia.scr.margint" marginb=&"f.config_dia.scr.marginb"]
;显示系统按钮层
[showsysbutton]
[trans method="crossfade" time=200]
[wt]
[current layer="message0" page="fore"]
[endmacro]
;------------------------------------------------------------------
;★透明全屏对话框
;------------------------------------------------------------------
[macro name=menu]
[rclick enabled="false"]
[history enabled="false"]
[backlay]
[freeimage layer=8 page="back"]
[current layer="message0" page="back"]
[position frame="" page="back" layer="message0" visible="true" width=&"kag.scWidth" height=&"kag.scHeight" color="0xFFFFFF" opacity="0" left=0 top=0 marginl=&"f.config_dia.blank.marginl" marginr=&"f.config_dia.blank.marginr" margint=&"f.config_dia.blank.margint" marginb=&"f.config_dia.blank.marginb"]
;隐藏系统按钮层
[hidesysbutton]
[trans method="crossfade" time=200]
[wt]
[current layer="message0" page="fore"]
[endmacro]
;------------------------------------------------------------
;★隐藏对话框
;------------------------------------------------------------
[macro name=hidemes]
[backlay]
;隐藏对话框
[layopt layer="message0" page="back" visible="false"]
;隐藏系统按钮
[layopt layer="message2" page="back" visible="false"]
;隐藏头像
[layopt layer=8 page="back" visible="false"]
[trans method="crossfade" time=100]
[wt]
[endmacro]
;------------------------------------------------------------
;★显示对话框
;------------------------------------------------------------
[macro name=showmes]
[backlay]
;隐藏对话框
[layopt layer="message0" page="back" visible="true"]
;隐藏系统按钮
[layopt layer="message2" page="back" visible="true"]
;隐藏头像
[layopt layer=8 page="back" visible="true" cond="kag.back.layers[8].width>32"]
[trans method="crossfade" time=100]
[wt]
[current layer=message0 page=back]
[er]
[current layer=message0 page=fore]
[endmacro]
;------------------------------------------------------------------
;★显示背景
;------------------------------------------------------------------
[macro name=bg]
[backlay]
;一般效果
[image * layer=stage storage=%storage|black page=back visible="true" left=0 top=0 grayscale=%grayscale|false mcolor=%mcolor mopacity=%mopacity]
;反色效果
[if exp="mp.convert==true"]
[image * layer=stage storage=%storage|black page=back visible="true" left=0 top=0 grayscale=%grayscale|false mcolor=%mcolor mopacity=%mopacity rceil=0 gceil=0 bceil=0 rfloor=255 bfloor=255 gfloor=255]
[endif]

;消除立绘
[if exp="mp.clfg==true"]
[freeimage layer=0 page="back"]
[freeimage layer=1 page="back"]
[freeimage layer=2 page="back"]
[freeimage layer=3 page="back"]
[freeimage layer=4 page="back"]
[freeimage layer=5 page="back"]
[freeimage layer=6 page="back"]
[freeimage layer=7 page="back"]
;[freeimage layer=event page="back"]
[freeimage layer=8 page="back"]
[endif]

;消除对话框
[if exp="mp.hidemes==true"]
[current layer="message0" page="back"]
[er]
[current layer="message1" page="back"]
[er]
[current layer="message2" page="back"]
[er]
[layopt layer="message0" visible="false" page="back"]
[layopt layer="message1" visible="false" page="back"]
[hidesysbutton]
[endif]

[trans method=%method|crossfade time=%time|700 rule=%rule stay=%stay from=%from]
[wt canskip=%canskip|true]
[endmacro]
;------------------------------------------------------------------
;★消除背景
;------------------------------------------------------------------
[macro name=clbg]
[backlay]
[freeimage layer=stage page="back"]
;连同全部前景
[if exp="mp.clfg==true"]
[freeimage layer=0 page="back"]
[freeimage layer=1 page="back"]
[freeimage layer=2 page="back"]
[freeimage layer=3 page="back"]
[freeimage layer=4 page="back"]
[freeimage layer=5 page="back"]
[freeimage layer=6 page="back"]
[freeimage layer=7 page="back"]

;[freeimage layer=event page="back"]
[freeimage layer=8 page="back"]
[endif]

;连同对话框
[if exp="mp.hidemes==true"]
[current layer="message0" page="back"]
[er]
[current layer="message1" page="back"]
[er]
[current layer="message2" page="back"]
[er]
[layopt layer="message0" visible="false" page="back"]
[layopt layer="message1" visible="false" page="back"]
[hidesysbutton]
[endif]

[trans method=%method|crossfade time=%time|700 rule=%rule stay=%stay from=%from]
[wt canskip=%canskip|true]
[endmacro]
;------------------------------------------------------------------
;★显示人物
;------------------------------------------------------------------
[macro name=fg]
[backlay]
;第一次显示,指定角色位置
[if exp="mp.pos!=''"]
[image * storage=%storage|empty layer=%layer|0 page="back" pos=%pos visible="true"]
[else]
;不指定时,自动调整,使立绘显示在原位置/指定位置
[eval exp="mp.layer='0'" cond="mp.layer==''"]
[eval exp="mp.left=kag.fore.layers[mp.layer].left" cond="mp.left==void"]
[eval exp="mp.top=kag.fore.layers[mp.layer].top" cond="mp.top==void"]
[image * storage=%storage layer=%layer page="back" left=%left top=%top visible="true"]
[endif]
[trans method=%method|crossfade time=%time|500 rule=%rule stay=%stay from=%from]
[wt canskip=%canskip|true]
[endmacro]
;------------------------------------------------------------------
;★消除人物
;------------------------------------------------------------------
[macro name=clfg]
[backlay]
;消除全部
[if exp="mp.layer=='all'"]
[freeimage layer=0 page="back"]
[freeimage layer=1 page="back"]
[freeimage layer=2 page="back"]
[freeimage layer=3 page="back"]
[freeimage layer=4 page="back"]
[freeimage layer=5 page="back"]
[freeimage layer=6 page="back"]
[freeimage layer=7 page="back"]
;[freeimage layer=event page="back"]
[freeimage layer=8 page="back"]
[endif]
;消除单层
[if exp="mp.layer!='all'"]
[freeimage layer=%layer|0 page="back"]
[endif]
;消除头像
[if exp="mp.clface==true"]
[freeimage layer=8 page="back"]
[endif]
;连同对话框
[if exp="mp.hidemes==true"]
[current layer="message0" page="back"]
[er]
[current layer="message1" page="back"]
[er]
[current layer="message2" page="back"]
[er]
[layopt layer="message0" visible="false" page="back"]
[layopt layer="message1" visible="false" page="back"]
[hidesysbutton]
[endif]
[trans method=%method|crossfade time=%time|500 rule=%rule stay=%stay from=%from]
[wt canskip=%canskip|true]
[endmacro]
;------------------------------------------------------------------
;★显示头像
;------------------------------------------------------------------
[macro name=face]
[backlay]
[image * layer=8 visible="true" page="back" storage=%storage|empty]
[layopt layer=8 page="back" left=&"(int)f.config_dia.face.left-kag.back.layers[8].width\2" top=&"(int)f.config_dia.face.top-kag.back.layers[8].height"]
;附加显示立绘
[if exp="mp.fg!=void"]
;在原位置显示图片
[eval exp="mp.layer='0'" cond="mp.layer==''"]
[eval exp="mp.left=kag.fore.layers[mp.layer].left"]
[eval exp="mp.top=kag.fore.layers[mp.layer].top"]
[image layer=%layer page="back" storage=%fg left=%left top=%top visible="true"]
[endif]
[trans method=%method|crossfade time=%time|100 rule=%rule|1]
[wt]
[endmacro]
;------------------------------------------------------------
;★播放音乐
;------------------------------------------------------------
[macro name=bgm]
[xchgbgm * storage=%storage overlap=%overlap|500 time=%time|1000]
[endmacro]
;------------------------------------------------------------
;★播放音效
;------------------------------------------------------------
[macro name=se]
[if exp="mp.time==void"]
[playse storage=%storage loop=%loop|false buf=%buf|0]
[else]
[fadeinse storage=%storage loop=%loop|false buf=%buf|0 time=%time|0]
[endif]
[endmacro]
;------------------------------------------------------------
;★播放语音
;------------------------------------------------------------
;播放语音（并进行历史记录回放处理）
[macro name=vo]
	[eval exp="f.voing=true"]
	[playse storage=%storage buf="1" loop="false"]
	[hact exp=&("playse("+"\""+mp.storage+"\""+")")]
[endmacro]
;语音结束（等待播放完毕，历史记录处理结束）
[macro name=endvo]
	;假如有语音正在播放才执行以下指令
	[if exp="f.voing==true"]
		[eval exp="f.voing=false"]
		[endhact]
		;仅在auto模式下进行语音等待
		[ws buf="1" canskip="true" cond="kag.autoMode==true"]
	[endif]
[endmacro]
;-------------------------------------------------------------------------------------------
;★播放视频
;-------------------------------------------------------------------------------------------
[macro name=mv]
[video visible="true" mode="mixer" width=&"kag.scWidth" height=&"kag.scHeight"]
[playvideo storage=%storage]
[wv canskip=%canskip|true]
[endmacro]
;-------------------------------------------------------------------------------------------
;★移动
;-------------------------------------------------------------------------------------------
[macro name=movepos]
[eval exp="tf.layer=0"]
[eval exp="tf.layer=mp.layer" cond="mp.layer!=''"]
[eval exp="tf.left=kag.fore.layers[tf.layer].left"]
[eval exp="tf.top=kag.fore.layers[tf.layer].top"]
[eval exp="tf.oop=kag.fore.layers[tf.layer].opacity"]
[eval exp="tf.x=0"]
[eval exp="tf.y=0"]
[eval exp="tf.opacity=kag.fore.layers[tf.layer].opacity"]
[eval exp="tf.x=mp.x" cond="mp.x!=''"]
[eval exp="tf.y=mp.y" cond="mp.y!=''"]
[eval exp="tf.opacity=mp.opacity" cond="mp.opacity!=''"]
[eval exp="tf.x2=tf.left*1+mp.x*1"]
[eval exp="tf.y2=tf.top*1+mp.y*1"]
[eval exp="tf.path='('+&tf.x2+','+&tf.y2+','+&tf.opacity+')'"]
[move layer=%layer|0 path="&tf.path" time=%time|100 accel=%accel]
[wm canskip=%canskip]
[endmacro]
;-------------------------------------------------------------------------------------------
;★背景摇晃
;-------------------------------------------------------------------------------------------
[macro name=shake]
[action layer=stage module=LayerWaveActionModule vibration=10 cycle=100 time=400 cond="mp.dir=='wave'"]
[action layer=stage module=LayerJumpActionModule vibration=10 cycle=100 time=400 cond="mp.dir=='jump'"]
[wact canskip=%canskip]
[endmacro]
;-------------------------------------------------------------------------------------------
[return]
