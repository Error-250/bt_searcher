# bt_searcher
bt/torrent searcher
# BT Search Framwork

<strong>Usage :</strong>
<pre>
exit           -- exit program
search content -- search torrent about content
next           -- next page
pre            -- pre page
get index [op] -- get op-information from index'th result
          [op] -- title, torrent, size, list
getsize        -- get results size
set options v  -- set options with v
getallconfigs  -- get all available configs
</pre>

<strong>Example :</strong>
<pre>
search 黑帮
#=>
odianying/ ...
odianying/ ...
meiju/YXHB ...
anying/HBJ ...
odianying/ ...
odianying/ ...
dianying/C ...
odianying/ ...
odianying/ ...
odianying/ ...
odianying/ ...
odianying/ ...
YGSSDDHWYH ...
odianying/ ...
meiju/YXHB ...
anying/HBD ...
meiju/LCHB ...
meiju/HBTS ...
dianying/H ...
iju/HBDFM/ ...
get 1 title
黑帮追缉令
get 1 list
#=>
file:thunder://QUFmdHA6Ly9keTpkeUB4bGouMnR1LmNjOjMxMDk4L1vRuMDXz8LU2Hd3dy4ydHUuY2Ndutqw79e3vKnB7i5CRDEwMjS438fl1tDTosur19Yucm12Ylpa
detail:黑帮追缉令BD1024高清中英双字
file:thunder://QUFmdHA6Ly9keTpkeUB4bGouMnR1LmNjOjMxMDk4L1vRuMDXz8LU2Hd3dy4ydHUuY2Ndutqw79e3vKnB7i5CRDEyODC438fl1tDTosur19Yucm12Ylpa
detail:黑帮追缉令BD1280高清中英双字
file:thunder://QUFmdHA6Ly9keTpkeUB4bGouMnR1LmNjOjMxMDk4L1vRuMDXz8LU2Hd3dy4ydHUuY2Ndutqw79e3vKnB7i5CRDEyODCzrMfl1tDTosur19YubWt2Wlo=
detail:黑帮追缉令BD1280超清中英双字
file:thunder://QUFmdHA6Ly9wOnBAZHguZGwxMjM0LmNvbTo4MDA2L1u159OwzOzMw3d3dy5keTIwMTguY29tXbrasO/Xt7ypwe5CRNbQ06LLq9fWLnJtdmJaWg==
detail:黑帮追缉令BD中英双字
file:thunder://QUFodHRwOi8vYnQubG9sZHl0dC5jb20vYnQvob5MT0y159OwzOzMw3d3dy5sb2xkeXR0LmNvbaG/W7rasO/Xt7ypwe5dW0JELTcyMFAtUk1WQl1b06LT79bQ19ZdW7a5sOo1Ljm31l1bMS4wR0JdWzIwMTRdLnRvcnJlbnRaWg==
detail:[黑帮追缉令][BD-720P-RMVB][英语中字][豆瓣5.9分][1.0GB][2014].torrent
file:thunder://QUFodHRwOi8vYnQubG9sZHl0dC5jb20vYnQvob5MT0y159OwzOzMw3d3dy5sb2xkeXR0LmNvbaG/W7rasO/Xt7ypwe5dW0JELTcyMFAtTVA0XVvTotPv1tDX1l1btrmw6jUuObfWXVsxLjZHQl1bMjAxNF0udG9ycmVudFpa
detail:[黑帮追缉令][BD-720P-MP4][英语中字][豆瓣5.9分][1.6GB][2014].torrent
</pre>

<strong>Supprots Web Site :</strong>
<pre>
so.loldytt.com
www.sobt5.org
# You can write a config file for other web site you want to support and use it.
</pre>

<strong>Declare : Do not use it to search any <em>illegal</em> source</strong>
