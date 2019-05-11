
--leds=62 --Küche
--leds=83 --Lang
leds=44 --kurz

ledBuffer=nil

print("-------------")
print("waiting 1s...")
print("use tmr.stop(0) to stop the init.lua")
tmr.alarm(0,1000,0,function()
	print("starting...")
	
	ws2812.init()
	ledBuffer = ws2812.newBuffer(leds, 3)
	ledBuffer:fill(0,0,0)
	ws2812.write(ledBuffer)
	dofile("animations.lc")
	anim1 = anim.worker(anim.rgba(255,0,0,0), 200,100,100,10,800,0)
	anim2 = anim.worker(anim.rgba(0,0,255,0), 10,50,50,-10,1000,300)
	anim3 = anim.worker(anim.rgba(0,255,0,0), 50,50,50,-10,900,0)
	anim4 = anim.worker(anim.rgba(0,0,255,0), 50,50,50,10,1300,1000)
	two=true
	tmr.alarm(1,30,1,function()
		anim1.wrk()
		anim2.wrk()
		if(two)then
			anim3.wrk()
			anim4.wrk()
			two=false
		else
			two=true
		end
		ledBuffer:mix(255, anim1.buffer, 255, anim2.buffer, 255, anim3.buffer, 255, anim4.buffer)
		ws2812.write(ledBuffer)
	end)
		
end)
