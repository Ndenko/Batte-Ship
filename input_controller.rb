require_relative '../models/game_board'
require_relative '../models/ship'
require_relative '../models/position'

# return a populated GameBoard or nil
# Return nil on any error (validation error or file opening error)
# If 5 valid ships added, return GameBoard; return nil otherwise
def read_ships_file(path)

    my_game = GameBoard.new 10, 10
    successful_ship_adds = 0
    i = 0
    valid_ships_array = Array.new()
    #add each VALID ship info to an array
    read_file_lines (path) do |line| 
        if line =~ /\([0-9]+,[0-9]+\), (Up|Down|Right|Left), [1-5]/
            valid_ships_array[i] = line
            i += 1
        end
        
    end
    
    #turn each valid ship info into a ship
    for j in 0..(valid_ships_array.length-1) do
        if valid_ships_array[j] =~ /\(([0-9]+),([0-9]+)\), (Up|Down|Right|Left), ([1-5])/
        
            my_position = Position.new($1.to_i,$2.to_i)
            my_orientation = $3
            my_size = $4.to_i
            my_ship = Ship.new(my_position, my_orientation, my_size)
            if my_game.add_ship(my_ship) == true
                successful_ship_adds += 1
            end
            #stop adding once we've gotten to 5, even if there are more
            if successful_ship_adds == 5
                return my_game
            end
        end

    end
    
    #if we've failed to hit 5, return nil
    return nil

   

   
end


# return Array of Position or nil
# Returns nil on file open error
def read_attacks_file(path)
    i = 0
    attack_positions_array = Array.new()
    #add each VALID position to an array
    read_file_lines (path) do |line| 
        if line =~ /\(([0-9]+),([0-9]+)\)/

            my_position = Position.new($1.to_i,$2.to_i)
            attack_positions_array[i] = my_position
            i += 1
        end
    end
    return attack_positions_array
end


# ===========================================
# =====DON'T modify the following code=======
# ===========================================
# Use this code for reading files
# Pass a code block that would accept a file line
# and does something with it
# Returns True on successfully opening the file
# Returns False if file doesn't exist
def read_file_lines(path)
    return false unless File.exist? path
    if block_given?
        File.open(path).each do |line|
            yield line
        end
    end

    true
end

#read_file_lines("C:/wsl/project1b/test/public/inputs/correct_ships_p1.txt") 
#read_ships_file("C:/wsl/project1b/test/public/inputs/bad_ships.txt")
#read_ships_file("C:/wsl/project1b/test/public/inputs/correct_ships_p1.txt").class
#read_ships_file("C:/wsl/project1b/test/public/inputs/correct_ships_p2.txt")
#read_attacks_file("C:/wsl/project1b/test/public/inputs/correct_strat_p1.txt")
#read_attacks_file("C:/wsl/project1b/test/public/inputs/correct_strat_p2.txt")
#read_attacks_file("C:/wsl/project1b/test/public/inputs/perfect_strat_p1.txt")
#read_attacks_file("C:/wsl/project1b/test/public/inputs/perfect_strat_p2.txt")
