# HTCart
## 一  ·  前言

早期以淘宝为代表的C2C网站以**“入驻店铺”**模式强势打破了纯线下的商品交易格局，而近年来，通过不断的尝试与改进，各大电商平台也趋于成熟并自成体系。以京东、聚美优品、网易考拉海购、唯品会、小红书为代表B2C平台也以**“自营+入驻店铺”**的垂直销售模式进入消费者的视野。但也有不少企业和商家为了避免缴纳高额的入驻保证金和平台年费等，选择开发自己的商城App产品，也就是**“自营”**模式。

购物车作为大多数商城中不可或缺的部分，其逻辑和设计往往也取决于商城本身的交易模式与商品的性质。以美团外卖、饿了么为例，作为一个主张快捷消费产品，加上配送的问题，跨店购物的模式显然不适用它，因此购物车的入口并不在一级菜单下，而是在每家店铺商品列表底部。其购物车显示的内容也相对简单，只需包括已选商品信息（名称、价格、数量、增减按钮）、餐盒费、配送费、总价即可。而对于一个功能完善的商城来说，购物车的逻辑显然会复杂许多，下文中将模仿淘宝购物车的需求，对逻辑功能进行整理和编码。<br>  
![美团外卖购物车](http://wx1.sinaimg.cn/mw690/ae7fac63gy1fgkqc713qwj20af08xt9z.jpg) 
## 二  ·  基本需求设计

#### 1、购物车入口

>a）点击App底部菜单的购物车TabbarItem进入

>b）从商品详情页的购物车按钮进入

这里要注意区分购物车列表高度的问题。

#### 2、店铺分区

当商城支持跨店购物，那么购物车内的所有商品需要按照不同的店铺分区显示，这个分类逻辑的步骤通常由后端完成，我们iOS端只需获取输出的数据在tableView中展示即可。店铺信息在section的headerView中展示，另外还会显示一个店铺选择按钮。

#### 3、商品cell中展示的信息

我们通常将商品cell分为*normal*、*edit* 两类状态，当然商品信息比较简单的情况下，也可以选择只有Edit状态。购物车中显示的商品信息包括：

>1）商品基本信息（展示图片、名称、规格、选择数量、价格（或现价、原价））

>2）限购信息/降价信息

>3）购物券满减信息、凑单按钮、活动标志（如狂欢节等）

>4）选择按钮

>5）其他

以上信息在显示的时候遵从一定上下顺序，cell的布局会根据以上信息的有无适当调整。

#### 4、底部核算界面

底部界面上功能比较明确——全选按钮、合计标签、结算按钮。

这部分的关键在于，合计价格和全选按钮的状态都会表单上面的商品选中情况变化。下文中将会分析一下其中的逻辑。

#### 5、商品的增删改

>商品的**添加**：1）从商城中添加；2）在购物车列表中增加。添加时需要考虑购物车列表是否已有相同的或是相同店铺的商品。

>商品的**删除**：1）*normal* 状态下侧滑删除；2）点击编辑按钮进入*edit* 状态，点击删除按钮。

>商品的**修改**：1）批量编辑修改；2）店铺编辑修改。修改内容包括商品数量和规格

以上五条涵盖了购物车的基本的功能需求，根据业务需要自行拓展。<br>  
![购物车效果图](http://wx2.sinaimg.cn/mw690/ae7fac63gy1fgkq5jrbjjj20af0j5q4q.jpg) 
## 三  ·  解决思路

#### 1、单选/店铺选择/全选联动模式

解决思路：

i）将全选按钮标记为`A`；

ii）购物车中`m`个店铺的选中按钮一次标记为`A(0),A(1),...,A(m-1)`；

iii）第`x`家店铺（`x∈(0,m-1)`）下的n个商品的选中按钮依次标记为`A(x,0),A(x,1),...,A(x,n-1)`。

那么：

`A(x,0),A(x,1),...,A(x,n-1)`全部选中可推导出`A(x)`选中；

`A(0),A(1),...,A(m-1)`全部选中可以推导出`A`选中。

点击某商品选择按钮`A(m,n)`的**伪代码**如下：

```

A(m,n).selected = !A(m,n).selected;

BOOL shopAllChoose = YES;

for (int i = 0; i < n; i++) {

        shopAllChoose &= A(m,i).selected;

}

A(m).selected = shopAllChoose;

BOOL allChoose = YES;

for (int j = 0; j < m; j++) {

        allChoose &= A(j).selected;

}

A.selected = allChoose;

```

点击某店铺全选和所有商品全选的代码原理相似。
#### 2、编辑模式
购物车设计中，出现两类编辑按钮：
>① 导航栏上的全选编辑

>② 每个section右上角的批量编辑

点击①类按钮，①文本变为“完成”，同时②类按钮隐藏，所有的cell进入*edit* 状态；
点击②类按钮，当前按钮文本变为“完成”，该section下所有cell进入*edit* 状态。

修改商品数量可以通过加减按钮，也可以通过手动输入修改。当然，修改前需要对当前的数量做出判断，是否还能进行加减，或是输入的数据是否合理，如出现限购信息等。

由于整个购物车的逻辑关系比较多，我们可以考虑将这部分功能单独放在一个UIView中处理，数量变化的具体实现可借鉴[PPNumberButton](https://github.com/jkpang/PPNumberButton)。

#### 3、删除模式
除了上文提到的*edit* 状态下点击删除按钮以外，还有一种就是在*normal* 状态左滑删除。<br>  
![*edit* 时删除](http://wx3.sinaimg.cn/mw690/ae7fac63gy1fgknxcwt7sj20ae03mjrh.jpg) <br>  
![*normal* 时删除](http://wx3.sinaimg.cn/mw690/ae7fac63gy1fgknvh7d00j20af03njrn.jpg) <br>
cell在*normal* 状态时可以左滑删除，而在*edit* 状态下点击删除，要在下面方法中做出`return YES/NO;`的判断和区分。

```
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {}
```
假如要自定义删除键，可以在`UITableViewRowAction`初始化时在`title`的定义部分，使用多个空格作为占位符，然后在`layoutSubviews`中找到cell图层上的`UITableViewCellDeleteConfirmationView`层添加上新定义的删除键。

#### 4、总价计算
总价计算公式很简单： ` 总价=Σ选中的商品的数量*选中的商品的单价`

但这个公式中存在两个变化量，一个是“**是否选中**”，一个是“**数量**”，也就是说总价刷新出现在以下场景：

>有商品的**选中状态**发生了改变： 点击了**单选/店铺选择/全选按钮**

>有选中的商品的**数量**发生改变：点击了**增加/减少**或者**编辑**了数量文本
