module Ghcli
	module Terminal
		class Term
			def initialize
				@offset_x = 0
				@offset_y = 0
				@offset_width = 0
				@offset_height = 0
			end

			def transform(offset_x, offset_y, offset_width, offset_height, &block)
				old_x, old_y, old_w, old_h = @offset_x, @offset_y, @offset_width, @offset_height
				@offset_x, @offset_y, @offset_width, @offset_height = old_x + offset_x, old_y + offset_y, offset_width, offset_height
				yielded = yield
				print ANSI::Code.move(convert_row(row), convert_col(col)) + yielded if yielded.is_a? String
				@offset_x, @offset_y, @offset_width, @offset_height = old_x, old_y, old_w, old_h
			end

			def clear
				print "\e[2J"
			end

			def reset
				clear
				move 0, 0
			end

			def home
				move convert_row(:top), convert_col(:left)
			end

			def move(row, col = nil)
				print ANSI::Code.move convert_row(row), convert_col(col)
			end

			def print_at(row, str)
				print ANSI::Code.move(convert_row row) + str
			end

			def dash_row(row)
				print_at convert_row(row), '-' * width
			end

			def width
				ANSI::Terminal.terminal_width
			end

			def height
				ANSI::Terminal.terminal_height
			end

			def print_list(start, list, &block)
				move start
				current_row = convert_row start
				content = list.map do |row|
					ANSI::Code.code(:clear_line) + (yield row, current_row) + ANSI::Code.move(current_row += 1)
				end.reduce :+
				print content
			end

			private

			def convert_row(arg)
				case arg
				when Integer
					arg
				when String
					convert_row arg.to_sym
				when :bottom
					height
				when :top
					0
				end
			end

			def convert_col(arg)
				case arg
				when Integer
					arg
				when String
					convert_col arg.to_sym
				when :left
					0
				when :right
					width
				end
			end
		end
	end
end
