function intro_play()
	-- If it already exists then get rid of it and just start over
	-- don't want to have to deal with duplicate CalcViews
	hook.Remove( "CalcView", "intro_fly_over" )

	local start = {
		Vector( 3066.283203, -2586.468750, 1088.031250 ),
		Vector( -9625.321289, 8862.187500, 1088.031250 )
	}

	local finish = {
		Vector( 325.266907, -2529.435059, 1424.310303 ),
		Vector( -9625.321289, 13624.841797, 1088.031250 )
		
	}

	local angle = {
		Angle( 10.691999, -179.940277, 0.000000 ),
		Angle( 1.816023, 129.899307, 0.000000 )
	}

	local fraction = 0 -- % of how far you are from start to finish, start on 0% obviously
	local lerptime = 12 -- transition time in seconds
	local count = 1 -- why lua starts on 1 i'll never know

	hook.Add("CalcView", "intro_fly_over", function( ply, pos, angles, fov )

		-- Thanks to NeatNit on Facepunch
		-- https://facepunch.com/showthread.php?t=1508566&p=49930423&viewfull=1#post49930423
		fraction = math.Clamp(fraction + FrameTime()/lerptime, 0, 1)
		if fraction == 0 then return end

		local view = {}
		view.origin = LerpVector( fraction, start[count], finish[count] )
		view.angles = angle[count]
		view.fov = fov
		view.drawviewer = true

		if view.origin:IsEqualTol( finish[count], 2 ) then
			-- Reset % complete
			fraction = 0

			-- Move to the next set of co-ords
			count = count + 1

			if count > #start then
				count = 1
			end
		end

		return view
	end)
end

function intro_stop()
	hook.Remove( "CalcView", "intro_fly_over" )
end
