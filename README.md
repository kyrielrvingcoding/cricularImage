# cricularImage
轮播图，手势，定时器
大体思路
1、滑动视图的contentSize只有三个自身大小，用到的数据源数组也只有三个数据
2、在每次滑动到新的一个页面的时候，从总的数据源数组中更换数据源数据的数据，把滑动视图的contentOffset设置到最中间的页面
3、pageControl的currentPage的位置根据当前页面的对应总的数据源数组中的位置
4、当手指拖动的时候，就把定时器关掉，当页面停止加速的时候就把定时器开开
5、必须把scrollView自带的两个UIImageVIew删掉,不然就刚开始就会出现错误。如果不删掉自带的两个UIImageView，那么subviews[i]中的图片赋值就要从第3个元素(下标为2开始)
