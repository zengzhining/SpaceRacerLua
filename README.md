## SDKBOX package
* admob(aleard in)
* review(already in )
* ga(already in)


## 需要做的
* 加入SDK抽象层，负责ga,ad,review(C)
* 加入暂停界面UI层 (C)
* 游戏界面加入角色 (C)
* 碰撞检测 (C)
* 随机生成敌人 (C)
* 角色爆炸动画 (C)

10.31 -- 11.4
* 游戏结束界面 (C)
* 加入游戏背景 (C)
* 可以加入震动功能 (C)
* 加入vungle广告 (C)
* 构思排名系统 (C) 
* 加入按下安卓返回键进入到暂停界面 (C)
* 广告播放次数限制 (C)
* 加入加速器 (C)
* 排名的显示 (C)
* 游戏速度可以调节 (C)
* 背景速度 (C)
* loading (C)
* restart逻辑 (C)
* 音效(菜单点击和角色爆炸)(C)
* 主角超过敌机时候需要有一个回调函数(C)
* 调整游戏速度 (C)
* 加速器应该可以动态调整速度 (C)

## 11.8 -- 11.12
* 生成两种不同类型的敌人(C)
* 角色原地复活逻辑 (C)
* 分数和排行可以被动更新 (C)
*加入另外一种颜色的子弹，对应另外一个角色，另外一个角色速度变慢，但是可以发射两发子弹(C)
* 死亡时候弹出对话框问是否观看一个广告原地复活，这个只能使用两次一局(C)
* 音效 (C)
* 音乐 (C)
* 全局游戏速度设置 (C)
* 连击系统，连续打击到三个相同颜色的敌人分数加倍 (C)
* 连击系统设置最分倍率 (C)
* 随机生成敌人 (C)
* 敌人AI (C)
* 复活广告播放设置 （C)
* 不应该在创建敌机时候设置速度 (C)
* commbo显示和刷新排行榜机制 (C)
* 显示观看广告继续的应该在玩家分数比较低的时候显示 (C)
* Plist数据读取和存储 (C)
* 全局数据存储  (C)

## 11.14--11.18
* 选择角色界面 (C)
* loading加入游戏提示(C)
* 加入模拟摇杆控制(C)
*　播放广告失败时候机体消失处理 (C)
* 敌人生成可视化设计 (C)
* 主角死后不可以发射子弹 (C)
* 敌人死后不可左右移动 (C)
* 发射子弹冷却时间短一些，让发射子弹具有力量感 (C)
* 加入Helper类处理一些动作 (C)
* 增加默认音效音乐音量大小配置 (C)
* 进入后台进入前台的回调 (C)

## 11.19--11.25
* 连击机制完善 (C)
* 开火按钮增大 (C)
* 限制子弹，增加能量槽，1s恢复1个，1s内开枪就不恢复(C)
* 调整音量 (C)
* 关卡设计为固定关卡而不是随机,一共十个关卡
* 调整游戏时间只能到10分钟最多

## 待定
* 玩家点击屏幕出现点粒子特效 (C)
* 结束界面加入进度条，到达开启新的人物
* 如何防止角色站在一个地方一直开炮不移动 (C)
* 可以学习斑鸠角色有两种子弹，对应不同的敌人（日后）
* 打倒敌人获得的分数跟子弹飞行时间相关，时间越长获得的分数越高（待定）
* 调整游戏抽象结构(BasePlane 与 MovedObject 类似)
* 使用clipnode 让敌人进入一个地方从另外一个地方出来，子弹也是如此
* json数据读取和存储
* 思考如何把一张图编程碎图类似粒子特效

## Bullet 分支
* 尝试加入发射子弹 (C)

## AI分支
* 尝试加入游戏AI（C)

## 加速开发
* 游戏层面加入关卡编辑器 (C)

## 测试使用模板

## 引擎层面
* 粒子特效抽象层
* 数据存储抽象层






## 暂停界面回调会对应Scene下面的对应回调方法

