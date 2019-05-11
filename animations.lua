
anim={}

anim.hsl=function(h_,s_,l_)
	return {h=h_,s=s_,l=l_}
end

anim.worker=function(col_, width_, r_up_, r_down_, vel_, dist_, offs_)
	local wrkr={}
	wrkr.col=col_
	wrkr.width=width_
	wrkr.r_up=r_up_
	if(wrkr.r_up<1)then wrkr.r_up=1 end
	wrkr.r_down=r_down_
	if(wrkr.r_down<1)then wrkr.r_down=1 end
	wrkr.vel=vel_
	wrkr.offs=offs_
	wrkr.dist=dist_
	wrkr.currPos=0
	wrkr.buffer=ws2812.newBuffer(leds, 3)
	wrkr.buffer:fill(0,0,0)
	wrkr.wrk=function()
		local v,dir,pos=wrkr.vel,1,1
		if(v<0)then
			dir=-1
			v=-v
			pos=leds
		end
		local c=anim.rgba(wrkr.col.r,wrkr.col.g,wrkr.col.b,0)
		if(wrkr.offs>0)then
			wrkr.offs=wrkr.offs-v
			return
		end
		if(wrkr.currPos>wrkr.r_up+wrkr.width+wrkr.r_down+wrkr.dist)then
			wrkr.currPos=0
		elseif(wrkr.currPos>wrkr.r_up+wrkr.width+wrkr.r_down)then
			c.a=0
		elseif(wrkr.currPos>wrkr.r_up+wrkr.width)then
			c.a=255-((wrkr.currPos-wrkr.r_up-wrkr.width)*255/wrkr.r_down)
		elseif(wrkr.currPos>wrkr.r_up)then
			c.a=255
		else
			c.a=wrkr.currPos*255/wrkr.r_up
		end
		wrkr.currPos=wrkr.currPos+v
		c=anim.combine(c)
		wrkr.buffer:shift(dir)
		wrkr.buffer:set(pos,c.g,c.r,c.b)
	end
	return wrkr
end

anim.rgba=function(r_,g_,b_,a_)
	return {r=r_,g=g_,b=b_,a=a_}
end

anim.combine=function(...)
	local r,g,b,a,cnt=0,0,0,0,0
	for i, v in ipairs(arg) do
		r=r+(v.r*v.a)
		g=g+(v.g*v.a)
		b=b+(v.b*v.a)
		a=a+v.a
		cnt=cnt+1
	end
	if(a>0)then
		if(cnt==1)then
			return anim.rgba(r/255,g/255,b/255,255)
		else
			return anim.rgba(r/a,g/a,b/a,255)
		end
	else
		return anim.rgba(0,0,0,255)
	end
end
anim.toRGB=function(hsl)
	local r,g,b,c,x,m
	c=(1000-math.abs((hsl.l*2)-1000))*hsl.s/1000
	x=c*(1000-math.abs(((hsl.h/60)%2000)-1000))/1000
	m=(hsl.l)-(c/2)
	if(hsl.h<=60000)then
		r,g,b=c,x,0
	elseif(hsl.h<=120000)then
		r,g,b=x,c,0
	elseif(hsl.h<=180000)then
		r,g,b=0,c,x
	elseif(hsl.h<=240000)then
		r,g,b=0,x,c
	elseif(hsl.h<=300000)then
		r,g,b=x,0,c
	elseif(hsl.h<=360000)then
		r,g,b=c,0,x
	end
	r=(r+m)*255/1000
	g=(g+m)*255/1000
	b=(b+m)*255/1000
	return g,r,b
end

anim.toDec=function(number)
	local str,tmp,s
	str=""
	if(number<0)then
		str="-"
		number=-number
	end
	str=str..number/1000
	tmp=number%1000
	if(tmp>0)then
		s=""
		for i=1,3 do
			s=""..tmp%10 ..s
			tmp=tmp/10
		end
		str=str.."."..s
	end
	return str
end

anim.setCurrState=function()
	local str = "lastColors = ["
	for i=1,4 do
		str=str.."new Color("..anim.toDec(anim.lastColor[i].h)..','
		str=str..anim.toDec(anim.lastColor[i].s*100)..','
		str=str..anim.toDec(anim.lastColor[i].l*100)..'),'
	end
	str=string.gsub(str..'];',',];','];').."\r\n"
	str=str..'cmd="'..cmd..'";\r\n'
	str=str..'setSpeed('..animSpeed..');\r\n'

	currState=str
end





