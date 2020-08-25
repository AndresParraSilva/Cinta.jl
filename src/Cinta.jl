module Cinta
export LineRetrieverFromString, LineRetrieverFromFile, Parameters, get_next_line, is_header, is_detail, get_output

abstract type LineRetriever end

struct Parameters
		base::Float32
		variation::Float32
end

function sorted_by_schedule(m::Array{Any})
	schedule = Dict([
			(1, 1), (7, 2),
			(2, 3), (8, 4),
			(3, 5), (9, 6),
			(4, 7), (10, 8),
			(5, 9), (11, 10),
			(6, 11), (12, 12),
			])
	return sort!(m, by=r->schedule[r[1]])
end

struct LineRetrieverFromString <: LineRetriever
	buffer::IOBuffer
	function LineRetrieverFromString(received_text::String)
			new(IOBuffer(received_text))
	end
end

struct LineRetrieverFromFile <: LineRetriever
	buffer::IOStream
	function LineRetrieverFromFile(file_name::String)
			new(open(file_name))
	end
end

get_next_line(t::LineRetrieverFromString) = eof(t.buffer) ? nothing : readline(t.buffer)
get_next_line(t::LineRetrieverFromFile) = eof(t.buffer) ? nothing : readline(t.buffer)

function is_header(line::String)
		header_re = r"cinta ruta [0-9]+ [0-9]+$"
		occursin(header_re, line)
end

function is_detail(line::String)
		detail_re = r"cinta [0-9]+$"
		occursin(detail_re, line)
end


function get_output(p::Parameters, t::LineRetriever)
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
		output = []

		line = get_next_line(t)
		while !isnothing(line)
				if is_header(line)
						step = 1
						m = match(cab, line).match
						ruta, vel_inc = parse(Int, split(m)[3]), parse(Int, split(m)[4])
						vel = Int(trunc(vel_inc / 100))
						inc = vel_inc % 100
						new_vel = p.base + (ref - inc) * p.variation
						button = abs(new_vel - 9) < abs(new_vel - 12) ? 9 : 12
						closest = abs(new_vel - vel) < abs(new_vel - button) ? vel : button
						append!(output, [[ruta, inc, string(43 - 4step) * ':', vel, '→', vel == closest ? dont_touch : button, new_vel == closest ? eq : new_vel > closest ? up : down, new_vel]])
						step += 1
				elseif is_detail(line)
						m = match(det, line).match
						vel_inc = parse(Int, split(m)[2])
						vel = Int(trunc(vel_inc / 100))
						inc = vel_inc % 100
						new_vel = p.base + (ref - inc) * p.variation
						button = abs(new_vel - 9) < abs(new_vel - 12) ? 9 : 12
						closest = abs(new_vel - vel) < abs(new_vel - button) ? vel : button
						append!(output, [[ruta, inc, string(43 - 4step) * ':', vel, '→', vel == closest ? dont_touch : button, new_vel == closest ? eq : new_vel > closest ? up : down, new_vel]])
						step += 1
				end
				line = get_next_line(t)
		end
		output = sorted_by_schedule(output)
		str_out = ""
		for r in output
				str_out *= join(r, '\t') * '\n'
		end
		return str_out
end

end