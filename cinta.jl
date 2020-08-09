using Printf

"""
    cinta()

Genera el cronograma de ajustes de velocidad
de la cinta.

Toma los valores de velocidad e inclinación
registrados en Notas.txt para cada programa de la
cinta y genera el cronograma de ajustes a realizar
en base a los objetivos establecidos como
base (velocidad en Km/h para la inclinación 3) y
var (variación en Km/h a decrementar por cada
unidad de inclinación que se incrementa a partir
de 3).

Ejemplo del archivo Notas.txt:
09/08/2020 06:32 cinta ruta 8 303
09/08/2020 06:36 cinta 805
09/08/2020 06:40 cinta 604
"""
function cinta()
	open("/home/andres/Dropbox/Notas.txt") do f
		base = 10.5
		var = .2
		step = 0
		ruta = 0
		cab = r"cinta ruta [0-9]+ [0-9]+$"
		det = r"cinta [0-9]+$"
		ref = 3
		button = 9
		up = Char(0xFE3D)
		down = Char(0xFE3E)
		eq = Char(0x1d117)
		dont_touch = Char(0xa555)
		println("Ruta\tInc\tMin\tVel ofrecida\t\tBotón\tSubir o bajar\tVel")
		for l in eachline(f)
			if occursin(cab, l)
				step = 1
				m = match(cab, l).match
				ruta, vel_inc = parse(Int, split(m)[3]), parse(Int, split(m)[4])
				vel = Int(trunc(vel_inc / 100))
				inc = vel_inc % 100
				new_vel = base + (ref - inc) * var
				button = abs(new_vel - 9) < abs(new_vel - 12) ? 9 : 12
				closest = abs(new_vel - vel) < abs(new_vel - button) ? vel : button
				@printf("%2d\t%2d\t%2d:\t%2d\t→\t%2s\t%s\t%4.1f\n", ruta, inc, 43 - 4step, vel, vel == closest ? dont_touch : button, new_vel == closest ? eq : new_vel > closest ? up : down, new_vel)
				step += 1
			elseif occursin(det, l)
				m = match(det, l).match
				vel_inc = parse(Int, split(m)[2])
				vel = Int(trunc(vel_inc / 100))
				inc = vel_inc % 100
				new_vel = base + (ref - inc) * var
				button = abs(new_vel - 9) < abs(new_vel - 12) ? 9 : 12
				closest = abs(new_vel - vel) < abs(new_vel - button) ? vel : button
				@printf("%2d\t%2d\t%2d:\t%2d\t→\t%2s\t%s\t%4.1f\n", ruta, inc, 43 - 4step, vel, vel == closest ? dont_touch : button, new_vel == closest ? eq : new_vel > closest ? up : down, new_vel)
				step += 1
			end
		end
	end
end

cinta()